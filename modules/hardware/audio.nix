{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.my.modules.hardware.audio;
in {
  options.my.modules.hardware.audio = {
    enable = mkEnableOption "Audio setting";
  };

  # https://nixos.wiki/wiki/PipeWire
  config = mkIf cfg.enable {
    sound.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    environment.systemPackages = with pkgs; [ pavucontrol ];
  };
}
