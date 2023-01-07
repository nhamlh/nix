{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.my.modules.gaming.steam;
in {
  options.my.modules.gaming.steam = {
    enable = mkEnableOption "What did you said about hardworking?";
  };

  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall =
        true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall =
        true; # Open ports in the firewall for Source Dedicated Server
    };
  };
}
