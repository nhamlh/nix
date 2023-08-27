{ config, lib, pkgs, ... }:

with lib;
let cfg = config.my.modules.graphical;
in {
  config = mkIf (cfg.enable && cfg.wm == "hyprland") {
    home-manager.users.nhamlh = {
      xdg.configFile."hypr/hyprland.conf".source = ./hyprland.conf;
    };
  };
}
