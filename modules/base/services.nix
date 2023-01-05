{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.my.modules.base.services;
in {
  options.my.modules.base.services = {
    enable = mkEnableOption "Enable base services";
  };

  config = mkIf cfg.enable { services.openssh.enable = true; };
}
