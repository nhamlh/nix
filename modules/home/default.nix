{ config, lib, pkgs, home-manager, ... }:

with builtins;
with lib;

let
  hm = home-manager.nixosModules.home-manager;
  secrets = import config.age.secrets.secrets.path;
  #NOTE: This password (created by mkpasswd -m sha-512) is for seed purpose. Must be updated after installation.
  defaultHashedPasswd =
    "$6$YrkWwzXEm7Aw11ie$gxRMYpvbdx6m07AGKsZxMCVcGN1br2Pm1y.yikHxxbIG0NsbTRhRNIZF42qmRK/GGPDVwxEHepcYMCwgc1QfW.";
in {
  imports = [ hm { } ./base ./graphical ];

  config = {
    users.users.nhamlh = {
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" ];
      home = "/home/nhamlh";
      hashedPassword = if secrets.nhamlh-passwd != "" then
        secrets.nhamlh-passwd
      else
        defaultHashedPasswd;
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
