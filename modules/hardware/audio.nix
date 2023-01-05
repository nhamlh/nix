{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.my.modules.hardware.audio;
in {
  options.my.modules.hardware.audio = {
    enable = mkEnableOption "Audio setting";
  };

  config = mkIf cfg.enable {
    sound.enable = true;
    hardware.pulseaudio.enable = true;
  };
}
