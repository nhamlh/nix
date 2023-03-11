{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.my.modules.graphical;
in {
  config = mkIf (cfg.enable && cfg.wm == "sway") {
    environment.systemPackages = with pkgs; [ wayland ];
  };
}
