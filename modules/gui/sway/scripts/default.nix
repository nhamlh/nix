{ pkgs, lib, ... }:

let
  # Helper to create a script with runtime deps wrapped
  mkScript = name: text: pkgs.writeShellScriptBin name ''
    set -euo pipefail
    ${text}
  '';

  sway-scripts = pkgs.symlinkJoin {
    name = "sway-scripts";
    paths = [
      cglaunch
      cgtoggle
      cggrep
      exit-wm
      screenshot-area
      record-area
      sway-unfullscreen
      wl-clipboard-manager
    ];

    buildInputs = [ pkgs.makeWrapper ];

    # Wrap each script with its runtime PATH dependencies
    postBuild = let
      wrap = name: runtimeInputs: ''
        wrapProgram $out/bin/${name} \
          --prefix PATH : "${lib.makeBinPath runtimeInputs}"
      '';
    in ''
      ${wrap "cglaunch" [ pkgs.systemd ]}
      ${wrap "cgtoggle" [ pkgs.systemd pkgs.coreutils ]}
      ${wrap "cggrep" [ pkgs.systemd pkgs.gnugrep ]}
      ${wrap "exit-wm" [ pkgs.systemd pkgs.swaylock pkgs.playerctl ]}
      ${wrap "screenshot-area" [ pkgs.grim pkgs.slurp pkgs.wl-clipboard pkgs.libnotify ]}
      ${wrap "record-area" [ pkgs.wf-recorder pkgs.slurp pkgs.libnotify ]}
      ${wrap "sway-unfullscreen" [ pkgs.sway pkgs.jq ]}
      ${wrap "wl-clipboard-manager" [ pkgs.clipman pkgs.rofi-wayland pkgs.bemenu pkgs.libnotify ]}
    '';
  };

  # ── cglaunch ──────────────────────────────────────────────────────
  cglaunch = pkgs.writeShellScriptBin "cglaunch" ''
    # cglaunch - Launch apps as systemd scopes for proper lifecycle management
    #
    # Usage: cglaunch [--term] <command>
    #
    # Launches a command under a systemd --user scope, enabling proper
    # lifecycle tracking via systemd. With --term, runs the command inside
    # a terminal (ghostty or alacritty).

    set -euo pipefail

    app=""
    term_cmd=""

    if [ "$1" = "--term" ]; then
        shift

        term_args=()
        if [[ "$1" == "-"* ]]; then
            while [[ "$#" -gt 1 ]] && [[ "$1" != "--" ]]; do
                term_args+=("$1")
                shift
            done
            [[ "$1" != "--" ]] || shift
        fi

        title="''${1##*/}"
        title="''${title:-terminal}"

        if command -v ghostty &>/dev/null; then
            term_cmd="ghostty"
        elif command -v alacritty &>/dev/null; then
            term_cmd="alacritty"
        else
            echo >&2 "cglaunch: --term requires ghostty or alacritty"
            exit 1
        fi

        app="''${term_cmd} ''${term_args[*]} --class ''${title}"
    else
        title="''${1##*/}"
        title="''${title:-app}"
    fi

    if [ "$(uname)" == "Linux" ]; then
        exec systemd-run --quiet --user --scope --slice app.slice \
            --unit "launch-''${title}-$(date '+%s%N')" -- "$app" "$@"
    else
        exec $app "$@"
    fi
  '';

  # ── cgtoggle ──────────────────────────────────────────────────────
  cgtoggle = pkgs.writeShellScriptBin "cgtoggle" ''
    # cgtoggle - Toggle apps (stop if running, launch if not)
    #
    # Usage: cgtoggle <name> <command>
    #
    # Checks if an app is running via its systemd scope name. If running,
    # stops it; otherwise launches it via cglaunch.

    set -Eeuo pipefail

    name="''${1:?Usage: cgtoggle <name> <command>}"
    shift

    if systemctl --user --type=service --type=scope --no-pager --no-legend list-units 2>/dev/null \
        | awk '{ print $1 }' | grep -q "launch-''${name}"; then
        systemctl --user --type=service --type=scope --no-pager --no-legend list-units 2>/dev/null \
            | awk '{ print $1 }' | grep "launch-''${name}" | xargs -r systemctl --user stop
    else
        exec cglaunch "$@"
    fi
  '';

  # ── cggrep ────────────────────────────────────────────────────────
  cggrep = pkgs.writeShellScriptBin "cggrep" ''
    # cggrep - Check if an app is running via systemd
    #
    # Usage: cggrep <name>
    #
    # Returns 0 if a systemd scope matching "launch-<name>" is active,
    # returns 1 otherwise.

    set -euo pipefail

    name="''${1:?Usage: cggrep <name>}"

    systemctl --plain --no-legend --user list-units 2>/dev/null \
        | grep -q "^launch-''${name}"
  '';

  # ── exit-wm ───────────────────────────────────────────────────────
  exit-wm = pkgs.writeShellScriptBin "exit-wm" ''
    # exit-wm - Session management (lock, logout, suspend, reboot, shutdown, switch to TTY)
    #
    # Usage: exit-wm [lock|logout|suspend|reboot|shutdown|tty]
    #
    # Provides centralized session control for sway/wayland compositors.
    # Uses swaylock for locking, loginctl for session management,
    # and systemctl for power operations.

    set -euo pipefail

    before_lock() {
        if command -v playerctl &>/dev/null; then
            playerctl -a pause 2>/dev/null || true
        fi
    }

    case "''${1:-}" in
        tty)
            systemctl --user stop sway-session.target 2>/dev/null || true
            if command -v swaymsg &>/dev/null; then
                swaymsg exit
            elif command -v hyprctl &>/dev/null; then
                hyprctl dispatch exit
            fi
            ;;
        lock)
            before_lock
            if command -v swaylock &>/dev/null; then
                exec swaylock
            else
                echo >&2 "exit-wm: swaylock not found"
                exit 1
            fi
            ;;
        logout)
            loginctl terminate-session "''${XDG_SESSION_ID:-self}"
            ;;
        suspend)
            before_lock
            systemctl -i suspend
            if command -v swaylock &>/dev/null; then
                swaylock
            fi
            ;;
        reboot)
            exec systemctl -i reboot
            ;;
        shutdown)
            exec systemctl -i poweroff
            ;;
        *)
            echo >&2 "Usage: $0 {tty|lock|logout|suspend|reboot|shutdown}"
            exit 2
            ;;
    esac
  '';

  # ── screenshot-area ───────────────────────────────────────────────
  screenshot-area = pkgs.writeShellScriptBin "screenshot-area" ''
    # screenshot-area - Screenshot with region selection
    #
    # Usage: screenshot-area
    #
    # Uses grim + slurp for interactive region selection. Saves the
    # screenshot to ~/Screenshots/ with a timestamp filename, copies it
    # to the clipboard via wl-copy, and shows a notification.

    set -euo pipefail

    screenshot_dir="''${HOME}/Screenshots"
    mkdir -p "''${screenshot_dir}"

    timestamp="$(date '+%Y-%m-%d-%H%M%S')"
    filename="''${screenshot_dir}/''${timestamp}.png"

    if geometry="$(slurp -d 2>/dev/null)"; then
        grim -g "''${geometry}" "''${filename}"
    else
        grim "''${filename}"
    fi

    if command -v wl-copy &>/dev/null; then
        wl-copy < "''${filename}"
    fi

    if command -v notify-send &>/dev/null; then
        notify-send -t 3000 "Screenshot saved" "''${filename}"
    fi

    echo "''${filename}"
  '';

  # ── record-area ───────────────────────────────────────────────────
  record-area = pkgs.writeShellScriptBin "record-area" ''
    # record-area - Screen recording with region selection
    #
    # Usage: record-area
    #
    # Uses wf-recorder + slurp for interactive region selection. Toggles
    # recording: if wf-recorder is already running, stops it; otherwise
    # prompts for a region and starts recording. Saves to ~/Videos/ with
    # a timestamp filename.

    set -euo pipefail

    if pkill -x wf-recorder 2>/dev/null; then
        if command -v notify-send &>/dev/null; then
            notify-send -t 2000 'Screen recording' 'Recording stopped'
        fi
        exit 0
    fi

    video_dir="''${HOME}/Videos"
    mkdir -p "''${video_dir}"

    timestamp="$(date '+%Y-%m-%d-%H%M%S')"
    filename="''${video_dir}/record_''${timestamp}.mp4"

    if command -v notify-send &>/dev/null; then
        notify-send -t 2000 'Screen recording' 'Select an area to start the recording...'
    fi

    if geometry="$(slurp -d 2>/dev/null)"; then
        wf-recorder -g "''${geometry}" -f "''${filename}"
    else
        wf-recorder -f "''${filename}"
    fi

    if command -v notify-send &>/dev/null; then
        notify-send -t 2000 'Screen recording' "Saved to ''${filename}"
    fi

    echo "''${filename}"
  '';

  # ── sway-unfullscreen ─────────────────────────────────────────────
  sway-unfullscreen = pkgs.writeShellScriptBin "sway-unfullscreen" ''
    # sway-unfullscreen - Daemon that auto-unfullscreens when a new window opens
    #
    # Usage: sway-unfullscreen
    #
    # Subscribes to sway IPC window events. When a new window opens while
    # another window is fullscreen, it unfullscreens the current window
    # and focuses the new one.

    set -euo pipefail

    if ! command -v swaymsg &>/dev/null; then
        echo >&2 "sway-unfullscreen: swaymsg not found"
        exit 1
    fi

    if ! command -v jq &>/dev/null; then
        echo >&2 "sway-unfullscreen: jq not found"
        exit 1
    fi

    swaymsg -t subscribe -m '[ "window" ]' | while read -r line; do
        change="$(echo "''${line}" | jq -r '.change')"
        if [ "''${change}" = "new" ]; then
            fullscreen_mode="$(swaymsg -t get_tree | jq -r '.. | select(.type?) | select(.focused==true).fullscreen_mode')"
            if [ "''${fullscreen_mode}" -eq 1 ]; then
                swaymsg fullscreen disable
                swaymsg '[con_id="'"$(echo "''${line}" | jq -r '.container.id')"'"]' focus
            fi
        fi
    done
  '';

  # ── wl-clipboard-manager ──────────────────────────────────────────
  wl-clipboard-manager = pkgs.writeShellScriptBin "wl-clipboard-manager" ''
    # wl-clipboard-manager - Clipboard manager with history
    #
    # Usage: wl-clipboard-manager [pick|clear|lock|unlock]
    #
    # Manages clipboard history using clipman. Integrates with rofi or
    # bemenu for picking from history. Supports locking/unlocking the
    # clipboard to prevent certain content from being recorded.

    set -euo pipefail

    app="$(basename "$0")"
    lockfile="''${XDG_RUNTIME_DIR:-/tmp}/''${app}.lock"

    case "''${1:-}" in
        pick)
            if command -v rofi &>/dev/null; then
                exec clipman pick --tool rofi
            elif command -v bemenu &>/dev/null; then
                exec clipman pick --tool bemenu
            else
                echo >&2 "''${app}: no picker tool found (install rofi or bemenu)"
                exit 1
            fi
            ;;
        clear)
            exec clipman clear
            ;;
        lock)
            touch "''${lockfile}"
            if command -v notify-send &>/dev/null; then
                notify-send -t 1500 'Clipboard' 'Tracking locked'
            fi
            ;;
        unlock)
            rm -f "''${lockfile}"
            if command -v notify-send &>/dev/null; then
                notify-send -t 1500 'Clipboard' 'Tracking unlocked'
            fi
            ;;
        *)
            echo >&2 "Usage: ''${app} {pick|clear|lock|unlock}"
            exit 1
            ;;
    esac
  '';

in sway-scripts
