{ config, lib, pkgs, ... }:

with lib;
let cfg = config.my.modules.graphical;
in {
  config = mkIf cfg.enable {
    
    home-manager.users.nhamlh = { 
      home.packages = with pkgs; [ i3 i3status-rust ];
      xdg.configFile."i3".source = ./i3;
    };
  };
}
