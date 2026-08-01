{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.my.modules.gui;

  # Import sway-scripts package
  sway-scripts = import ./scripts { inherit pkgs lib; };

  # Solarized dark color palette
  solarized = {
    base03  = "#002b36";
    base02  = "#073642";
    base01  = "#586e75";
    base00  = "#657b83";
    base0   = "#839496";
    base1   = "#93a1a1";
    base2   = "#eee8d5";
    base3   = "#fdf6e3";
    yellow  = "#b58900";
    orange  = "#cb4b16";
    red     = "#dc322f";
    magenta = "#d33682";
    violet  = "#6c71c4";
    blue    = "#268bd2";
    cyan    = "#2aa198";
    green   = "#859900";
  };

  # Workspace names with Nerd Font icons
  ws1 = "1:";
  ws2 = "2:";
  ws3 = "3:_";
  ws4 = "4:_";
  ws5 = "5:_";
  ws6 = "6:_";

  # Lock script using swaylock with configurable wallpaper path
  slock = pkgs.writeShellScriptBin "slock" ''
    WALLPAPER=''${SWAY_WALLPAPER:-$HOME/.config/wallpapers/TimeFlies.jpg}
    exec swaylock -f -e --indicator-radius 150 -i "$WALLPAPER"
  '';

  # Helper to build systemd user service definitions
  mkSwayService = { description, execStart, partOf ? [ "sway-session.target" ] }: {
    Unit = {
      Description = description;
      PartOf = partOf;
      After = partOf;
    };
    Service = {
      Type = "simple";
      ExecStart = execStart;
      Restart = "on-failure";
      RestartSec = 3;
    };
    Install.WantedBy = partOf;
  };
in {
  config = mkIf (cfg.enable && cfg.wm == "sway") {
    # NixOS-level sway configuration
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };

    services.gnome.gnome-keyring.enable = true;

    # Ensure xdg-desktop-portal-gtk can recover if it starts before the
    # Wayland display is ready.
    systemd.user.services.xdg-desktop-portal-gtk = {
      partOf = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = 2;
      };
    };

    home-manager.users.nhamlh = {
      # ── Packages ──────────────────────────────────────────────────
      home.packages = with pkgs; [
        # Core sway ecosystem
        swaybg
        swaylock
        swayidle
        swayr
        swaynotificationcenter
        wldash
        wf-recorder

        # Screenshot / recording
        grim
        slurp
        wl-clipboard

        # Input debugging
        wev

        # Workspace auto-rename
        swayest-workstyle

        # Auto-brightness
        wluma

        # Launcher
        wofi

        # Our scripts
        sway-scripts
        slock

        # Clipboard manager
        clipman

        # Existing packages kept for compatibility
        bemenu
        dracula-theme
        adwaita-icon-theme
        xdg-utils
        glib
      ];

      # ── swaylock configuration ────────────────────────────────────
      programs.swaylock = {
        enable = true;
        settings = {
          color = solarized.base03;
          ignore-empty-password = true;
          indicator-radius = 100;
          indicator-thickness = 10;
          inside-clear-color = solarized.base02;
          inside-color = solarized.base03;
          inside-ver-color = "${solarized.orange}1c";
          inside-wrong-color = "${solarized.base3}1c";
          key-hl-color = "${solarized.base3}80";
          line-clear-color = "00000000";
          line-color = "00000000";
          line-ver-color = "00000000";
          line-wrong-color = "00000000";
          ring-clear-color = "${solarized.orange}30";
          ring-color = solarized.base02;
          ring-ver-color = "${solarized.base3}00";
          ring-wrong-color = "${solarized.base3}55";
          separator-color = "${solarized.base02}60";
          text-caps-lock-color = "00000000";
          text-clear-color = solarized.base02;
          text-ver-color = "00000000";
          text-wrong-color = "00000000";
        };
      };

      # ── swaync (notification center) ─────────────────────────────
      services.swaync = {
        enable = true;
        settings = {
          image-visibility = "when-available";
          hide-on-clear = true;
          positionY = "bottom";
        };
      };

      # ── swayr (window switcher) ──────────────────────────────────
      programs.swayr = {
        enable = true;
        systemd.enable = true;
        settings = {
          focus = {
            lockin_delay = 0;
          };
        };
      };

      # ── sworkstyle (workspace auto-rename) ───────────────────────
      xdg.configFile."sworkstyle/config.toml".text = ''
        fallback = ""

        [matching]
        "Alacritty" = ""
        "code" = ""
        "Code" = ""
        "firefox" = ""
        "Firefox" = ""
        "chromium" = ""
        "Chromium" = ""
        "Slack" = "_"
        "TelegramDesktop" = ""
        "discord" = ""
        "mpv" = "_"
        "spotify" = ""
        "thunar" = ""
        "org.gnome.Nautilus" = ""
        "kitty" = ""
        "Alacritty" = ""
        "ghostty" = ""
        "dmenu" = ""
        "wofi" = ""
        "pavucontrol" = ""
        "org.pwmt.zathura" = ""
        "calibre-gui" = ""
        "Signal" = ""
        "thunderbird" = ""
        "virt-manager" = "龍"
        "Gimp" = ""
        "krita" = ""
        "swappy" = ""
        "peek" = ""
        "qalculate-gtk" = ""
        "vimiv" = ""
        "org.gnumeric.gnumeric" = ""
        "abiword" = ""
      '';

      # ── wluma (auto-brightness) ──────────────────────────────────
      xdg.configFile."wluma/config.toml".text = ''
        [als.none]

        [[output.backlight]]
        name = "eDP-1"
        path = "/sys/class/backlight/intel_backlight"
        capturer = "wayland"
      '';

      # ── wldash (dashboard/launcher) ──────────────────────────────
      xdg.configFile."wldash/config.yaml".text = ''
        ---
        outputMode: active
        scale: 1
        background:
          red: 0.0
          green: 0.18
          blue: 0.21
          opacity: 0.9
        widget: !margin
          margins: [30, 30, 30, 30]
          widget: !verticalLayout
            - !horizontalLayout
              - !margin
                margins: [0, 132, 0, 48]
                widget: !verticalLayout
                  - !date
                    font: ~
                    font_size: 96.0
                  - !clock
                    font: ~
                    font_size: 384.0
              - !verticalLayout
                - !margin
                  margins: [0, 0, 0, 12]
                  widget: !battery
                    font: ~
                    font_size: 36.0
                    length: 0
            - !calendar
              font_primary: ~
              font_secondary: ~
              font_size: 24.0
              sections: 3
            - !launcher
              font: ~
              font_size: 48.0
              length: 0
              app_opener: "wofi -S drun"
              term_opener: "ghostty"
              url_opener: "xdg-open"

        fonts:
          sans: sans
          mono: mono
      '';

      # ── sway structured config via home-manager ──────────────────
      wayland.windowManager.sway = {
        enable = true;
        package = null; # use the NixOS system-level sway package
        xwayland = true;
        checkConfig = false;
        systemd.enable = true;
        # bindkeysToCode = true; # removed — option not available in our home-manager version

        extraConfig = ''
          # ── Window appearance ────────────────────────────────────
          default_border pixel 2
          default_floating_border none
          hide_edge_borders --i3 none
          tiling_drag disable

          # ── for_window rules ─────────────────────────────────────
          for_window [app_id=".*"] sticky enable
          for_window [app_id="dmenu.*"] floating enable, resize set width 60ppt height 80ppt
          for_window [app_id="wofi"] floating enable, resize set width 60ppt height 80ppt
          for_window [app_id="mpv"] resize set width 500, move position 1000 30
          for_window [app_id="pavucontrol"] floating enable, resize set width 60ppt height 80ppt
          for_window [app_id="blueberry"] floating enable
          for_window [app_id="nm-connection-editor"] floating enable

          # ── Resize mode ──────────────────────────────────────────
          set $mode_resize "Resize window"
          mode $mode_resize {
              bindsym --to-code {
                  h            exec swaymsg resize grow   left 10 || swaymsg resize shrink right 10
                  Ctrl+h       exec swaymsg resize grow   left 1  || swaymsg resize shrink right 1
                  j            exec swaymsg resize shrink up   10 || swaymsg resize grow   down  10
                  Ctrl+j       exec swaymsg resize shrink up   1  || swaymsg resize grow   down  1
                  k            exec swaymsg resize grow   up   10 || swaymsg resize shrink down  10
                  Ctrl+k       exec swaymsg resize grow   up   1  || swaymsg resize shrink down  1
                  l            exec swaymsg resize shrink left 10 || swaymsg resize grow   right 10
                  Ctrl+l       exec swaymsg resize shrink left 1  || swaymsg resize grow   right 1

                  # Arrow keys
                  Left         exec swaymsg resize grow   left 10 || swaymsg resize shrink right 10
                  Down         exec swaymsg resize shrink up   10 || swaymsg resize grow   down  10
                  Up           exec swaymsg resize grow   up   10 || swaymsg resize shrink down  10
                  Right        exec swaymsg resize shrink left 10 || swaymsg resize grow   right 10

                  # back to normal: Enter or Escape
                  Return mode default
                  Escape mode default
              }
          }

          # ── System exit mode ─────────────────────────────────────
          set $mode_system "System exit"
          mode $mode_system {
              bindsym --to-code {
                  l exec slock, mode "default"
                  e exec swaymsg exit, mode "default"
                  s exec systemctl suspend, mode "default"
                  r exec systemctl reboot, mode "default"
                  h exec systemctl poweroff, mode "default"

                  # back to normal: Enter or Escape
                  Return mode default
                  Escape mode default
              }
          }

          # ── Clipboard manager ────────────────────────────────────
          set $mode_clipboard "Clipboard manager"
          mode $mode_clipboard {
              bindsym --to-code {
                  d exec clipman pick --tool wofi, mode "default"
                  c exec clipman clear, mode "default"

                  Return mode default
                  Escape mode default
              }
          }
        '';

        config = {
          # ── Input devices ────────────────────────────────────────
          input = {
            "type:keyboard" = {
              xkb_layout = "us";
              xkb_options = "ctrl:nocaps";
              repeat_delay = "300";
              repeat_rate = "60";
            };
            "type:touchpad" = {
              natural_scroll = "enabled";
              tap = "enabled";
              click_method = "button_areas";
            };
          };

          # ── Seat ─────────────────────────────────────────────────
          seat."*".hide_cursor = "10000";

          # ── Output ───────────────────────────────────────────────
          output."*".bg = "${solarized.base03} solid_color";

          # ── Gaps ─────────────────────────────────────────────────
          gaps = {
            inner = 5;
            smartGaps = true;
          };

          # ── Window ───────────────────────────────────────────────
          window.hideEdgeBorders = "none";

          # ── Focus ────────────────────────────────────────────────
          focus = {
            wrapping = "yes";
            mouseWarping = false;
            followMouse = false;
          };

          # ── Bars ─────────────────────────────────────────────────
          bars = [ ];

          # ── Colors (Solarized dark) ──────────────────────────────
          colors = {
            focused = {
              border = solarized.base01;
              background = solarized.base01;
              text = solarized.base3;
              indicator = solarized.base01;
              childBorder = solarized.base03;
            };
            focusedInactive = {
              border = solarized.base01;
              background = solarized.base01;
              text = solarized.base3;
              indicator = solarized.base01;
              childBorder = solarized.base03;
            };
            unfocused = {
              border = solarized.base02;
              background = solarized.base02;
              text = solarized.base0;
              indicator = solarized.base02;
              childBorder = solarized.base03;
            };
            urgent = {
              border = solarized.red;
              background = solarized.red;
              text = solarized.base3;
              indicator = solarized.red;
              childBorder = solarized.base03;
            };
            placeholder = {
              border = solarized.base03;
              background = solarized.base03;
              text = solarized.base03;
              indicator = solarized.base03;
              childBorder = solarized.base03;
            };
          };

          # ── Floating criteria ────────────────────────────────────
          floating = {
            criteria = [
              { window_role = "pop-up"; }
              { app_id = "udiskie"; }
              { app_id = "dmenu.*"; }
              { app_id = "wofi"; }
              { app_id = "pavucontrol"; }
              { app_id = "mpv"; }
              { app_id = "nm-connection-editor"; }
              { app_id = "blueberry"; }
              { app_id = "qalculate-gtk"; }
            ];
            modifier = "Mod4";
          };

          # ── Keybindings ──────────────────────────────────────────
          keybindings =
            let
              mod = "Mod4";
              modS = "Mod4+Shift";
              modC = "Mod4+Ctrl";
              modA = "Mod4+Alt";
            in {
              # ── Terminal ──────────────────────────────────────────
              "${mod}+Return" = "exec ghostty";
              "${modS}+Return" = "exec ghostty";

              # ── Launcher ──────────────────────────────────────────
              "${mod}+space" = "exec wofi -S drun";
              "${modA}+d" = "exec wldash";

              # ── Lock screen ───────────────────────────────────────
              "${mod}+n" = "exec slock";

              # ── Kill focused window ───────────────────────────────
              "${mod}+q" = "kill";

              # ── Vim-style navigation ──────────────────────────────
              "${mod}+h" = "focus left";
              "${mod}+j" = "focus down";
              "${mod}+k" = "focus up";
              "${mod}+l" = "focus right";

              # Arrow keys
              "${mod}+Left"  = "focus left";
              "${mod}+Down"  = "focus down";
              "${mod}+Up"    = "focus up";
              "${mod}+Right" = "focus right";

              # ── Move focused window ───────────────────────────────
              "${modS}+h" = "move left";
              "${modS}+j" = "move down";
              "${modS}+k" = "move up";
              "${modS}+l" = "move right";

              "${modS}+Left"  = "move left";
              "${modS}+Down"  = "move down";
              "${modS}+Up"    = "move up";
              "${modS}+Right" = "move right";

              # ── Fullscreen ────────────────────────────────────────
              "${mod}+f" = "fullscreen toggle";

              # ── Container layout ──────────────────────────────────
              "${mod}+s" = "layout stacking";
              "${mod}+w" = "layout tabbed";
              "${mod}+e" = "layout toggle split";

              # ── Split toggle ──────────────────────────────────────
              "${modA}+s" = "split toggle";

              # ── Focus parent / child ──────────────────────────────
              "${mod}+a" = "focus parent";
              "${mod}+d" = "focus child";

              # ── Toggle tiling / floating ──────────────────────────
              "${modS}+space" = "floating toggle";

              # ── Scratchpad ────────────────────────────────────────
              "${mod}+minus" = "scratchpad show";
              "${modS}+minus" = "move scratchpad";

              # ── Toggle sticky ─────────────────────────────────────
              "${modS}+s" = "sticky toggle";

              # NOTE: "${mod}+Return" is already bound to the terminal above;
              # "focus mode_toggle" was a duplicate and has been removed.

              # ── Workspace switching ───────────────────────────────
              "${mod}+1" = "workspace number ${ws1}";
              "${mod}+2" = "workspace number ${ws2}";
              "${mod}+3" = "workspace number ${ws3}";
              "${mod}+4" = "workspace number ${ws4}";
              "${mod}+5" = "workspace number ${ws5}";
              "${mod}+6" = "workspace number ${ws6}";

              "${modS}+Tab"  = "workspace prev";

              # ── Move window to workspace ──────────────────────────
              "${modS}+1" = "move container to workspace number ${ws1}";
              "${modS}+2" = "move container to workspace number ${ws2}";
              "${modS}+3" = "move container to workspace number ${ws3}";
              "${modS}+4" = "move container to workspace number ${ws4}";
              "${modS}+5" = "move container to workspace number ${ws5}";
              "${modS}+6" = "move container to workspace number ${ws6}";

              # ── Focus output (multi-monitor) ──────────────────────
              "${modC}+h" = "focus output left";
              "${modC}+l" = "focus output right";
              "${modC}+Left"  = "focus output left";
              "${modC}+Right" = "focus output right";

              # ── Screenshots ───────────────────────────────────────
              "${mod}+Print" = "exec ${sway-scripts}/bin/screenshot-area";
              "${modS}+Print" = "exec ${sway-scripts}/bin/screenshot-area";
              "Print" = "exec ${sway-scripts}/bin/screenshot-area";
              "Shift+Print" = "exec ${sway-scripts}/bin/screenshot-area";

              # ── Screen recording ──────────────────────────────────
              "${modA}+Print" = "exec ${sway-scripts}/bin/record-area";
              "${modA}+Shift+Print" = "exec ${sway-scripts}/bin/record-area";

              # ── Swayr window switcher ─────────────────────────────
              "${mod}+Tab" = "exec swayr switch-to-urgent-or-lru-window";

              # ── Resize mode ───────────────────────────────────────
              "${mod}+r" = "mode $mode_resize";

              # ── System exit mode ──────────────────────────────────
              "${modS}+e" = "mode $mode_system";

              # ── Clipboard manager mode ────────────────────────────
              "${modA}+grave" = "mode $mode_clipboard";

              # ── Media keys ────────────────────────────────────────
              "--locked XF86AudioPlay"  = "exec playerctl --player playerctld play-pause";
              "--locked XF86AudioNext"  = "exec playerctl --player playerctld next";
              "--locked XF86AudioPrev"  = "exec playerctl --player playerctld previous";
              "--locked XF86AudioStop"  = "exec playerctl --player playerctld stop";

              "--locked XF86AudioMute"        = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
              "--locked XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
              "--locked XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
              "--locked XF86AudioMicMute"     = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";

              # ── Brightness keys ───────────────────────────────────
              "--locked XF86MonBrightnessUp"   = "exec brightnessctl set 5%+";
              "--locked XF86MonBrightnessDown" = "exec brightnessctl set 5%-";

              # ── Reload config ─────────────────────────────────────
              "${modS}+c" = "reload";

              # ── Exit sway ─────────────────────────────────────────
              "${modS}+q" = "exec swaynag -t warning -m 'Exit sway?' -b 'Yes' 'swaymsg exit'";
            };

          # ── Startup programs ────────────────────────────────────
          startup = [
            # Import Wayland env into the systemd+D-Bus user environment and
            # start the graphical session. Required because sway is launched
            # from a TTY (no display manager): without this, WAYLAND_DISPLAY
            # never reaches the systemd user environment, graphical-session.target
            # stays inactive, and xdg-desktop-portal-* / waybar fail to start.
            # SWAYSOCK is imported so waybar (started as a systemd service) can
            # talk to the sway IPC socket.
            {
              command = "dbus-update-activation-environment --systemd WAYLAND_DISPLAY DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE SWAYSOCK && systemctl --user start sway-session.target";
              always = false;
            }
            # swayidle: lock after 300s, dpms off after 600s
            {
              command = "${pkgs.swayidle}/bin/swayidle -w \
                timeout 300 '${slock}/bin/slock' \
                timeout 600 '${lib.getExe' pkgs.sway "swaymsg"} \"output * dpms off\"' \
                resume '${lib.getExe' pkgs.sway "swaymsg"} \"output * dpms on\"' \
                before-sleep '${slock}/bin/slock'";
              always = true;
            }
            # swaybg: set wallpaper
            {
              command = "${pkgs.swaybg}/bin/swaybg -i $HOME/.config/wallpapers/TimeFlies.jpg -m fill";
              always = true;
            }
            # swaync: notification daemon
            {
              command = "${pkgs.swaynotificationcenter}/bin/swaync";
              always = true;
            }
            # dex: XDG autostart
            {
              command = "${pkgs.dex}/bin/dex -a";
              always = true;
            }
            # polkit-gnome: authentication agent
            {
              command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
              always = true;
            }
            # sway-unfullscreen daemon
            {
              command = "${sway-scripts}/bin/sway-unfullscreen";
              always = true;
            }
            # workstyle: auto-rename workspaces
            {
              command = "${lib.getExe pkgs.swayest-workstyle} --deduplicate";
              always = true;
            }
          ];
        };
      };

      # ── Systemd user services ────────────────────────────────────
      systemd.user.services = {
        wluma = mkSwayService {
          description = "wluma - auto brightness";
          execStart = "${lib.getExe pkgs.wluma}";
        };

        clipman = mkSwayService {
          description = "Clipboard manager daemon (clipman)";
          execStart = "${lib.getExe pkgs.clipman} --no-persist";
        };
      };
    };
  };
}
