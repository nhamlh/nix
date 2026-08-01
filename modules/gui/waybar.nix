{ options, config, lib, pkgs, ... }:
with builtins;
with lib;
let
  cfg = config.my.modules.gui;

  # Custom exec scripts bundled together via symlinkJoin
  waybar-scripts = pkgs.symlinkJoin {
    name = "waybar-scripts";
    paths = with pkgs; [
      (writeShellScriptBin "waybar-recording" ''
        if pgrep -x wf-recorder > /dev/null; then
          printf '{"text": " ", "class": "recording"}\n'
        else
          printf '{"text": ""}\n'
        fi
      '')
      (writeShellScriptBin "waybar-systemd" ''
        failed_user="$(
          systemctl --plain --no-legend --user list-units --state=failed \
            | awk '{ print $1 }'
        )"
        failed_system="$(
          systemctl --plain --no-legend list-units --state=failed \
            | awk '{ print $1 }'
        )"
        failed_systemd_count="$(echo -n "$failed_system" | grep -c '^')"
        failed_user_count="$(echo -n "$failed_user" | grep -c '^')"
        text=$(( failed_systemd_count + failed_user_count ))
        if [ "$text" -eq 0 ]; then
          printf '{"text": ""}\n'
        else
          tooltip=""
          [ -n "$failed_system" ] && \
            tooltip="Failed system services:\\n\\n''${failed_system}\\n\\n''${tooltip}"
          [ -n "$failed_user" ] && \
            tooltip="Failed user services:\\n\\n''${failed_user}\\n\\n''${tooltip}"
          tooltip="$(printf "$tooltip" | perl -pe 's/\n/\\n/g' | perl -pe 's/(?:\\n)+$//')"
          printf '{"text": " %s", "tooltip": "%s"}\n' "$text" "$tooltip"
        fi
      '')
      (writeShellScriptBin "waybar-dnd" ''
        # Subscribe to swaync state changes and emit waybar JSON
        ${lib.getExe' pkgs.swaynotificationcenter "swaync-client"} --subscribe-waybar
      '')
      bash
      coreutils
      gnugrep
      gawk
      perl
      procps
      systemd
    ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/waybar-recording --prefix PATH : $out/bin
      wrapProgram $out/bin/waybar-systemd   --prefix PATH : $out/bin
      wrapProgram $out/bin/waybar-dnd       --prefix PATH : $out/bin
    '';
  };
in {
  config = mkIf (cfg.enable && cfg.wm == "sway") {
    home-manager.users.nhamlh = {
      programs.waybar = {
        enable = true;
        systemd.enable = true;

        style = ''
          @define-color critical #ff0000;
          @define-color warning  #f3f809;
          @define-color fgcolor  #ffffff;
          @define-color bgcolor  #222436;
          @define-color alert    #df3320;

          @define-color accent1 #ff7a93;
          @define-color accent2 #b9f27c;
          @define-color accent3 #ff9e64;
          @define-color accent4 #bb9af7;
          @define-color accent5 #7da6ff;
          @define-color accent6 #0db9d7;

          @define-color green   #b9f27c;
          @define-color yellow  #f3f809;
          @define-color red     #ff0000;

          * {
            border: none;
            border-radius: 0;
            font-family: "JetBrainsMono Nerd Font";
            font-size: 14px;
            min-height: 0;
          }

          window#waybar {
            background-color: rgba(34, 36, 54, 0.6);
            color: #ffffff;
            transition-property: background-color;
            transition-duration: 0.5s;
          }

          window#waybar.hidden {
            opacity: 0.2;
          }

          #workspaces button {
            padding: 0 6px;
            margin: 4px 0;
            background-color: transparent;
            color: #ffffff;
            min-width: 28px;
            border-top: 2px solid transparent;
            border-bottom: 2px solid transparent;
          }

          #workspaces button.active {
            background-color: #ddddff;
            color: #303030;
            border-bottom: 2px solid @green;
          }

          #workspaces button.focused {
            background-color: #bbccdd;
            color: #323232;
            border-bottom: 2px solid @green;
          }

          #workspaces button.urgent {
            border-bottom: 2px solid @yellow;
            color: red;
          }

          #workspaces button:hover {
            background: rgba(0, 0, 0, 0.2);
          }

          #mode {
            background-color: #64727D;
            border-bottom: 2px solid @red;
          }

          #clock,
          #battery,
          #cpu,
          #memory,
          #temperature,
          #backlight,
          #network,
          #pulseaudio,
          #custom-media,
          #tray,
          #mode,
          #idle_inhibitor,
          #custom-power,
          #custom-pacman,
          #custom-launcher,
          #custom-recording,
          #custom-systemd,
          #custom-dnd,
          #custom-separator,
          #language {
            padding: 0 6px;
            margin: 4px 3px 5px 3px;
            color: @fgcolor;
            background-color: transparent;
          }

          #window,
          #workspaces {
            margin: 0 4px;
          }

          .modules-left > widget:first-child > #workspaces {
            margin-left: 0;
          }

          .modules-right > widget:last-child > #workspaces {
            margin-right: 0;
          }

          #clock {
            color: #90ee90;
          }

          #battery {
            color: @accent5;
          }

          #battery.warning {
            border-bottom: 2px solid @yellow;
          }

          #battery.critical:not(.charging) {
            background-color: @critical;
            color: #ffffff;
            border-bottom: 2px solid @red;
          }

          #battery.charging {
            border-bottom: 2px solid @green;
          }

          @keyframes blink {
            to {
              background-color: #ffffff;
              color: #333333;
            }
          }

          label:focus {
            background-color: #000000;
          }

          #cpu {
            color: @accent1;
          }

          #cpu.warning {
            border-bottom: 2px solid @yellow;
          }

          #cpu.critical {
            border-bottom: 2px solid @red;
          }

          #memory {
            color: #86e2d5;
          }

          #memory.warning {
            border-bottom: 2px solid @yellow;
          }

          #memory.critical {
            border-bottom: 2px solid @red;
          }

          #backlight {
            color: @accent2;
          }

          #network {
            color: @accent3;
          }

          #network.disconnected {
            color: @alert;
          }

          #pulseaudio {
            color: @accent4;
          }

          #pulseaudio.muted {
            color: #a0a0a0;
          }

          #custom-launcher {
            color: @accent6;
          }

          #custom-powermenu {
            color: @accent6;
          }

          #custom-pacman {
            color: @accent2;
          }

          #custom-media {
            background-color: #66cc99;
            color: #2a5c45;
            min-width: 100px;
          }

          #custom-media.custom-spotify {
            background-color: #66cc99;
          }

          #custom-media.custom-vlc {
            background-color: #ffa000;
          }

          #temperature {
            color: @accent6;
          }

          #temperature.critical {
            background-color: @critical;
          }

          #tray {
            /* Hidden via negative margin like max-baz-dotfiles */
            margin-left: -1000000px;
          }

          #idle_inhibitor {
            background-color: #343434;
            border-radius: 4px;
          }

          #mpd {
            color: #d1e231;
          }

          #custom-language {
            color: @accent5;
            min-width: 16px;
          }

          #custom-separator {
            color: #606060;
            margin: 0 1px;
            padding-bottom: 5px;
          }

          #custom-recording {
            color: #c71585;
          }

          #custom-recording.recording {
            border-bottom: 2px solid @red;
          }

          #custom-audiorec {
            color: #c71585;
          }

          #custom-systemd {
            color: @alert;
          }

          #custom-systemd {
            border-bottom: 2px solid @red;
          }

          #custom-dnd.dnd-notification,
          #custom-dnd.dnd-none {
            border-bottom: 2px solid @yellow;
          }

          /* Hover effects for clickable modules */
          #custom-launcher:hover,
          #custom-powermenu:hover,
          #custom-recording:hover,
          #custom-dnd:hover {
            background-color: rgba(255, 255, 255, 0.1);
            border-radius: 4px;
          }

          /* Tooltip styling */
          tooltip {
            background-color: @bgcolor;
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 4px;
          }

          tooltip label {
            color: @fgcolor;
          }
        '';

        settings = [{
          layer = "top";
          position = "top";
          height = 30;
          margin-top = 3;
          margin-bottom = 2;

          modules-left = [
            "custom/launcher"
            "sway/workspaces"
            "sway/mode"
          ];

          modules-center = [ ];

          modules-right = [
            "tray"
            "custom/separator"
            "idle_inhibitor"
            "custom/separator"
            "backlight"
            "custom/separator"
            "cpu"
            "custom/separator"
            "memory"
            "custom/separator"
            "disk"
            "custom/separator"
            "battery"
            "custom/separator"
            "pulseaudio"
            "custom/separator"
            "network"
            "custom/separator"
            "custom/recording"
            "custom/separator"
            "custom/systemd"
            "custom/separator"
            "custom/dnd"
            "custom/separator"
            "clock"
            "custom/separator"
            "custom/powermenu"
          ];

          "custom/launcher" = {
            format = " ";
            on-click = "pkill rofi || rofi2";
            on-click-middle = "exec default_wall";
            on-click-right = "exec wallpaper_random";
            tooltip = false;
          };

          "sway/workspaces" = {
            disable-scroll = true;
            all-outputs = true;
            format = " {icon} ";
          };

          "pulseaudio" = {
            scroll-step = 5;
            format = "{icon} {volume}% {format_source}";
            format-muted = "󰖁 Muted";
            on-click = "pamixer -t";
            tooltip = false;

            format-bluetooth = "{icon} {volume}% {format_source}";
            format-bluetooth-muted = " {format_source}";

            format-source = " {volume}%";
            format-source-muted = "";
            format-icons = {
              headphone = "";
              hands-free = "";
              headset = "🎧";
              phone = "";
              portable = "";
              car = "";
              default = [ "" "" "" ];
            };
          };

          "memory" = {
            interval = 1;
            format = "  {used:0.2f}GB";
            states = {
              warning = 75;
              critical = 90;
            };
            max-length = 10;
            tooltip = false;
          };

          "cpu" = {
            interval = 1;
            format = "󰍛 {usage}%";
            tooltip = false;
            on-click = "alacritty -e btm";
          };

          "disk" = {
            format = "  {free}";
          };

          "custom/recording" = {
            format = " Rec";
            format-disabled = " Off-air";
            return-type = "json";
            interval = 1;
            exec = "${waybar-scripts}/bin/waybar-recording";
            exec-if = "pgrep wf-recorder";
          };

          "custom/audiorec" = {
            format = "♬ Rec";
            format-disabled = "♬ Off-air";
            return-type = "json";
            interval = 1;
            exec = "echo '{\"class\": \"audio recording\"}'";
            exec-if = "pgrep ffmpeg";
          };

          "custom/systemd" = {
            format = "{}";
            return-type = "json";
            interval = 10;
            exec = "${waybar-scripts}/bin/waybar-systemd";
          };

          "custom/dnd" = {
            tooltip = false;
            format = "{icon}";
            format-icons = {
              notification = "";
              none = "";
              dnd-notification = "";
              dnd-none = "";
            };
            return-type = "json";
            exec = "${waybar-scripts}/bin/waybar-dnd";
            on-click = "${lib.getExe' pkgs.swaynotificationcenter "swaync-client"} --toggle-dnd --skip-wait";
            on-click-right = "${lib.getExe' pkgs.swaynotificationcenter "swaync-client"} --toggle-panel";
            escape = true;
          };

          "network" = {
            format-disconnected = "󰯡 Disconnected";
            format-ethernet = "󰒢 Connected!";
            format-linked = "󰖪 {essid} (No IP)";
            format-wifi = "󰖩 {essid}";
            format-alt = "{ifname}: {ipaddr}/{cidr}";
            interval = 1;
            tooltip-format = "{essid}: {ipaddr}";
          };

          "temperature" = {
            critical-threshold = 80;
            format = "{icon}&#8239;{temperatureC}°C";
            format-icons = [ "" "" "" ];
          };

          "backlight" = {
            format = "{icon}&#8239;{percent}%";
            format-icons = [ "💡" "💡" ];
            on-scroll-down = "brightnessctl -c backlight set 1%-";
            on-scroll-up = "brightnessctl -c backlight set +1%";
          };

          "battery" = {
            states = {
              warning = 30;
              critical = 15;
            };
            format = "{icon}&#8239;{capacity}%";
            format-charging = "&#8239;{capacity}%";
            format-plugged = "&#8239;{capacity}%";
            format-alt = "{icon} {time}";
            format-icons = [ "" "" "" "" "" ];
          };

          "custom/powermenu" = {
            format = "";
            on-click = "pkill rofi || ~/.config/rofi/powermenu/type-3/powermenu.sh";
            tooltip = false;
          };

          "clock" = {
            interval = 1;
            locale = "C";
            format = "  {:%I:%M %p}";
            format-alt = "  {:%a,%b %d}";
          };

          "idle_inhibitor" = {
            format = "{icon}";
            format-icons = {
              activated = "";
              deactivated = "";
            };
          };

          "custom/separator" = {
            format = " | ";
            interval = "once";
            tooltip = false;
          };

          "tray" = {
            icon-size = 20;
            spacing = 7;
          };
        }];
      };
    };
  };
}
