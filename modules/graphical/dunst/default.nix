{ config, lib, pkgs, ... }:

with lib;
let cfg = config.my.modules.graphical;
in {
  config = mkIf cfg.enable {
    home-manager.users.nhamlh = {
      # notification system
      home.packages = with pkgs; [ dunst ];

      xdg.configFile."dunstrc".source = ./dunstrc;
    };
  };
}
