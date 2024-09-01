{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.my.modules.graphical;
  screenshot = pkgs.writeTextFile {
    name = "screenshot";
    destination = "/bin/screenshot";
    executable = true;
    text = ''
      FILE=$HOME/Screenshots/$(date "+%Y-%m-%d-%H%M%S").png
      if [[ $@ == "-g" ]]; then
         grim -g "$(slurp)" - | tee $FILE | wl-copy
      else
         grim  - | tee $FILE | wl-copy
      fi
    '';
  };

  slock = pkgs.writeTextFile {
    name = "slock";
    destination = "/bin/slock";
    executable = true;
    text = ''
      # FIXME: $HOME/.config/wallpaper -> xdg.configFile.wallpapers
      # xdg is only avail within home-manager so can't eval it here
      swaylock -f -e --indicator-radius 150 -i $HOME/.config/wallpapers/TimeFlies.jpg
    '';
  };
in {
  config = mkIf (cfg.enable && cfg.wm == "sway") {
    environment.systemPackages = with pkgs; [ wayland ];

    home-manager.users.nhamlh = {
      home.packages = with pkgs; [
        sway
        swaylock
        swayidle
        grim # screenshot functionality
        slurp # screenshot functionality
        wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
        bemenu # wayland clone of dmenu
        dracula-theme # gtk theme
        adwaita-icon-theme # default gnome cursors
        xdg-utils # for openning default programms when clicking links
        glib # gsettings
        screenshot
        slock
      ];

      xdg.configFile."sway/config".source = ./sway;
    };

    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };

  };
}
