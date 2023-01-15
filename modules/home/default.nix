{ config, lib, pkgs, home-manager, ... }:

let hm = home-manager.nixosModules.home-manager;
in {
  imports = [ hm { } ./base ./graphical ];

  config = {
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

    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;

    home-manager.users.nhamlh = {
      home.username = "nhamlh";
      home.homeDirectory = "/home/nhamlh";

      home.stateVersion = "22.05";
      programs.home-manager.enable = true;
    };
  };
}
