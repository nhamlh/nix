{ config, pkgs, home-manager, ... }:

{
  imports = [ ./hardware.nix ];

  networking.hostName = "amd-desktop";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Ho_Chi_Minh";

  my.modules = {
    hardware = {
      audio.enable = true;
      bluetooth.enable = true;
      hidpi.enable = true;
    };

    containers.enable = true;

    services = { grafana-agent.enable = true; };
    graphical = { enable = true; };
    gaming = { steam.enable = true; };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nhamlh = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    home = "/home/nhamlh";
    #NOTE: This password (created by mkpasswd -m sha-512) is for seed purpose. Must be updated after installation.
    hashedPassword =
      "$6$aQoR2srY/MEt/QsN$US5maz2FoHLqMKVAWjsGVOpEsNXN4HgYEqexlkiGb59XOc/HqTxd8p0UDzVERmISGuYd0Y6hj4Z9pfDlzT3150";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKmPhGYUluyUQ2j/pcF+2hyC38HBMnkyPYd3Mq3IlI8d nhamlh@somewhereonearth"
    ];
  };
  system.stateVersion = "22.05"; # Did you read the comment?
}
