{ config, lib, pkgs, ... }:
with builtins;
with lib;
let cfg = config.my.modules.graphical;
in {
  config = mkIf cfg.enable {
    home-manager.users.nhamlh = {
      programs.waybar = {
        enable = true;
        systemd = { enable = false; };
        style = ''
          @define-color critical #ff0000; /* critical color */
          @define-color warning #f3f809;  /* warning color */
          @define-color fgcolor #ffffff;  /* foreground color */
          @define-color bgcolor #303030;  /* background color */
          @define-color bgcolor #222436;  /* background color */
          @define-color alert   #df3320;

          @define-color accent1 #ff7a93;
          @define-color accent2 #b9f27c;
          @define-color accent3 #ff9e64;
          @define-color accent4 #bb9af7;
          @define-color accent5 #7da6ff;
          @define-color accent6 #0db9d7;

          * {
              /* `otf-font-awesome` is required to be installed for icons */
              border: none;
              font-family: "JetBrainsMono";
              /* Recommended font sizes: 720p: ~14px, 1080p: ~18px */
              font-size: 18px;
          }

          window#waybar {

              background-color: rgba(34, 36, 54, 0.6);
              border-bottom: 0px solid rgba(100, 114, 125, 0.5);
              color: #ffffff;
              transition-property: background-color;
              transition-duration: .5s;
              border-radius: 4px;
          }

          window#waybar.hidden {
              opacity: 0.2;
          }

          #workspaces button {
              padding: 0px;
              margin: 4px 0 6px 0;
              background-color: transparent;
              color: #ffffff;
              min-width: 36px;
          }

          #workspaces button.active {
              padding: 0 0 0 0;
              margin: 4px 0 6px 0;
              background-color: #ddddff;
              color: #303030;
              min-width: 36px;
          }

          #workspaces button:hover {
              background: rgba(0, 0, 0, 0.2);
          }

          #workspaces button.focused {
              background-color: #bbccdd;
              color: #323232;
          }

          #workspaces button.urgent {
              color: red;
          }

          #mode {
              background-color: #64727D;
              border-bottom: 1px solid #ffffff;
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
          #language {
              padding: 0px 3px;
              margin: 4px 3px 5px 3px;
              color: @fgcolor;
              background-color:transparent;
          }

          #window,
          #workspaces {
              margin: 0 4px;
          }

          /* If workspaces is the leftmost module, omit left margin */
          .modules-left > widget:first-child > #workspaces {
              margin-left: 0;
          }

          /* If workspaces is the rightmost module, omit right margin */
          .modules-right > widget:last-child > #workspaces {
              margin-right: 0;
          }

          #clock {
              color: #90ee90;
          }

          #battery {
              color: @accent5;
          }

          @keyframes blink {
              to {
                  background-color: #ffffff;
                  color: #333333;
              }
          }

          #battery.critical:not(.charging) {
              background-color: @critical;
              color: @white;
          }

          label:focus {
              background-color: #000000;
          }

          #cpu {
              color: @accent1;
          }

          #memory {
              color: #86e2d5;
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

          #custom-power {
              color: @accent6;
          }

          #custom-waylandvsxorg {
              color: @accent5;
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

          #custom-wmname {
              min-width: 36px;
              font-size: 15px;
          }

          #custom-recorder,
          #custom-audiorec {
              color: #c71585;
          }
        '';
        settings = [{
          "layer" = "top";
          "position" = "top";
          "height" = 35;
          "margin-top" = 3;
          "margin-bottom" = 2;
          modules-left =
            [ "custom/wmname" "sway/workspaces" "wlr/workspaces" "sway/mode" ];
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
            "clock"
          ];

          "custom/launcher" = {
            "format" = " ";
            "on-click" = "pkill rofi || rofi2";
            "on-click-middle" = "exec default_wall";
            "on-click-right" = "exec wallpaper_random";
            "tooltip" = false;
          };

          "sway/workspaces" = {
            "disable-scroll" = true;
            "all-outputs" = true;
            "format" = " {icon} ";
          };

          "pulseaudio" = {
            "scroll-step" = 5;
            "format" = "{icon} {volume}% {format_source}";
            "format-muted" = "󰖁 Muted";
            #"format-muted"= "  {format_source}";
            "on-click" = "pamixer -t";
            #"on-click" = "pavucontrol";
            "tooltip" = false;

            "format-bluetooth" = "{icon} {volume}% {format_source}";
            "format-bluetooth-muted" = " {format_source}";

            "format-source" = " {volume}%";
            "format-source-muted" = "";
            "format-icons" = {
              "headphone" = "";
              "hands-free" = "";
              "headset" = "🎧";
              "phone" = "";
              "portable" = "";
              "car" = "";
              "default" = [ "" "" "" ];
            };

          };

          "memory" = {
            "interval" = 1;
            #"format" = "󰻠 {percentage}%";
            "format" = "  {used:0.2f}GB";
            "states" = {
              "warning" = 75;
              "critical" = 90;
            };
            "max-length" = 10;
            "tooltip" = false;
          };

          "cpu" = {
            "interval" = 1;
            "format" = "󰍛 {usage}%";
            #"format"= " &#8239;{usage}%";
            "tooltip" = false;
            "on-click" = "alacritty -e btm";
          };

          "disk" = { "format" = "  {free}"; };

          "custom/recorder" = {
            "format" = " Rec";
            "format-disabled" =
              " Off-air"; # An empty format will hide the module.
            "return-type" = "json";
            "interval" = 1;
            "exec" = "echo '{\"class\": \"recording\"}'";
            "exec-if" = "pgrep wf-recorder";
          };

          "custom/audiorec" = {
            "format" = "♬ Rec";
            "format-disabled" =
              "♬ Off-air"; # An empty format will hide the module.
            "return-type" = "json";
            "interval" = 1;
            "exec" = "echo '{\"class\": \"audio recording\"}'";
            "exec-if" = "pgrep ffmpeg";
          };

          "network" = {
            "format-disconnected" = "󰯡 Disconnected";
            "format-ethernet" = "󰒢 Connected!";
            "format-linked" = "󰖪 {essid} (No IP)";
            "format-wifi" = "󰖩 {essid}";
            "format-alt" = "{ifname}: {ipaddr}/{cidr}";
            "interval" = 1;
            "tooltip-format" = "{essid}: {ipaddr}";

            #"format-wifi": " &#8239;({signalStrength}%)",
            #"format-ethernet": "&#8239;{ifname}: {ipaddr}/{cidr}",
            #"format-linked": "&#8239;{ifname} (No IP)",
            #"format-disconnected": "✈ &#8239;Disconnected",
          };

          "temperature" = {
            # "thermal-zone"= 2;
            # "hwmon-path"= "/sys/class/hwmon/hwmon2/temp1_input";
            "critical-threshold" = 80;
            # "format-critical"= "{temperatureC}°C {icon}";
            "format" = "{icon}&#8239;{temperatureC}°C";
            "format-icons" = [ "" "" "" ];
          };

          "backlight" = {
            # "device"= "acpi_video1";
            "format" = "{icon}&#8239;{percent}%";
            "format-icons" = [ "💡" "💡" ];
            "on-scroll-down" = "brightnessctl -c backlight set 1%-";
            "on-scroll-up" = "brightnessctl -c backlight set +1%";
          };

          "battery" = {
            "states" = {
              # "good"= 95;
              "warning" = 30;
              "critical" = 15;
            };
            "format" = "{icon}&#8239;{capacity}%";
            "format-charging" = "&#8239;{capacity}%";
            "format-plugged" = "&#8239;{capacity}%";
            "format-alt" = "{icon} {time}";
            # "format-good"= ""; // An empty format will hide the module
            # "format-full"= "";
            "format-icons" = [ "" "" "" "" "" ];
            #/ "format-icons": ["", "", "", "", ""]
          };

          "custom/powermenu" = {
            "format" = "";
            "on-click" =
              "pkill rofi || ~/.config/rofi/powermenu/type-3/powermenu.sh";
            "tooltip" = false;
          };

          "clock" = {
            "interval" = 1;
            "locale" = "C";
            "format" = "  {:%I:%M %p}";
            "format-alt" = "  {:%a,%b %d}";
          };

          "idle_inhibitor" = {
            "format" = "{icon}";
            "format-icons" = {
              "activated" = "";
              "deactivated" = "";
            };
          };

          "custom/separator" = {
            "format" = " | ";
            "interval" = "once";
            "tooltip" = false;
          };

          "tray" = {
            "icon-size" = 20;
            "spacing" = 7;
          };
        }];
      };
    };
  };
}
