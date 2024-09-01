{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.my.modules.gui;
in {
  config = mkIf (cfg.enable && cfg.wm == "hyprland") {
    programs.hyprland.enable = true;

    home-manager.users.nhamlh = {
      xdg.configFile."hypr/hyprland.conf".source = ./hyprland.conf;
    };
  };
}
