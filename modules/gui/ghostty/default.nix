{ config, lib, pkgs, ... }:

with lib;
let cfg = config.my.modules.gui;
in {
  config = mkIf cfg.enable {
    home-manager.users.nhamlh = {
      home.packages = with pkgs; [ ghostty ];

      xdg.configFile."ghostty/config".source = ./config;
    };
  };
}
