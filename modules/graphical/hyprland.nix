{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.my.modules.graphical;
in {
  config = mkIf (cfg.enable && cfg.wm == "hyprland") {
    programs.hyprland.enable = true;
  };
}
