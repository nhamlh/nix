{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.my.modules.base.services;
in {
  config = {
    services.openssh.enable = true;
    programs.ssh.startAgent = true;
    # gnome-keyring enables gcr-ssh-agent since 25.11; keep OpenSSH agent.
    services.gnome.gcr-ssh-agent.enable = false;
  };
}
