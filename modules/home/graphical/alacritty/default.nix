{ config, lib, pkgs, ... }:

with lib;
let cfg = config.my.modules.graphical;
in {
  config = mkIf cfg.enable {
    home-manager.users.nhamlh = {
      home.packages = with pkgs; [ alacritty ];

      # Fix hidden cursor after typing and need to move the cursor out of Alacritty windows for it to be visible again.
      home.pointerCursor = {
        name = "Adwaita";
        package = pkgs.gnome.adwaita-icon-theme;
        size = 24;
        x11 = {
          enable = true;
          defaultCursor = "Adwaita";
        };
      };

      xdg.configFile."alacritty/alacritty.yml".source = ./alacritty.yml;
    };
  };
}
