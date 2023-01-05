{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.my.modules.hardware.bluetooth;
  declareFor = name:{};
in {
  options.my.modules.hardware.bluetooth = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
  };
}
