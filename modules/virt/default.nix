{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.my.modules.containers;
in {
  options.my.modules.containers = {
    enable = mkEnableOption "Containerization";
  };

  imports = [ ./k3s.nix ];

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [ docker-compose ];

    virtualisation.docker.enable = true;
    virtualisation.docker.liveRestore = false;
  };
}
