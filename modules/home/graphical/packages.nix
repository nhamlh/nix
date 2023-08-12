{ config, lib, pkgs, ... }:

with lib;
let cfg = config.my.modules.graphical;
in {
  config = mkIf cfg.enable {
    home-manager.users.nhamlh = {
      home.packages = with pkgs; [
        nvtop
        dex # generate and execute DesktopEntry files of the type Application
        feh
        firefox
        chromium
        tdesktop
        zoom-us
        drawio
      ];
    };
  };
}
