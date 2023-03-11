{ config, lib, pkgs, ... }:

with lib;
let cfg = config.my.modules.graphical;
in {
  config = mkIf (cfg.enable && cfg.wm == "i3") {
    services.xserver.windowManager.i3.enable = true;
    services.xserver.windowManager.i3.package = pkgs.i3-gaps;

    home-manager.users.nhamlh = {
      home.packages = with pkgs; [ xbindkey i3status-rust feh scrot ];

      home.file.".xbindkeysrc".source = ./xbindkeysrc;
      home.file.".Xresources".source = ./Xresources;
      xdg.configFile."i3/config".source = ./i3/config;
      xdg.configFile."i3/i3status-rs.toml".source = ./i3/i3status-rs.toml;
      xdg.configFile."compton.conf".source = ./i3/compton.conf;
    };
  };
}
