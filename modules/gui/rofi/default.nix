{ config, lib, pkgs, ... }:

with lib;
let cfg = config.my.modules.gui;
in {
  config = mkIf cfg.enable {
    home-manager.users.nhamlh = {
      home.packages = with pkgs; [ rofi ];
      xdg.configFile."rofi/config.rasi".source = ./config.rasi;
      xdg.configFile."rofi/solarized.rasi".source = ./solarized.rasi;
      xdg.configFile."rofi/glue_pro_blue.rasi".source = ./glue_pro_blue.rasi;
    };
  };
}
