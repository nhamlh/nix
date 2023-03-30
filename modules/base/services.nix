{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.my.modules.base.services;
in {
  config = {
    services.openssh.enable = true;
    programs.ssh.startAgent = true;
  };
}
