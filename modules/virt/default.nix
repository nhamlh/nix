{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.my.modules.containers;
in {
  options.my.modules.containers = {
    enable = mkEnableOption "Containerization";
  };

  config = mkIf cfg.enable { virtualisation.docker.enable = true; };
}
