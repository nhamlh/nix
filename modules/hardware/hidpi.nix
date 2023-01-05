{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.my.modules.hardware.hidpi;
in {
  options.my.modules.hardware.hidpi = {
    enable = mkEnableOption "high-resolution display";
  };

  config =
    mkIf cfg.enable { hardware.video.hidpi.enable = lib.mkDefault true; };
}
