{ config, lib, pkgs, ... }:

with lib;
let cfg = config.my.modules.graphical;
in {
  config = mkIf cfg.enable {
    home-manager.users.nhamlh = {
      home.packages = with pkgs; [ alacritty ];

      xdg.configFile."alacritty/alacritty.yml".source = ./alacritty.yml;
    };
  };
}
