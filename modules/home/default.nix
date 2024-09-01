{ config, lib, pkgs, home-manager, ... }:

with builtins;
with lib;

let
  hm = home-manager.nixosModules.home-manager;
  secrets = config.age.secrets.secrets.path;

in {
  imports = [ hm { } ];

  config = {
    users.users.nhamlh = {
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" ];
      home = "/home/nhamlh";
      hashedPasswordFile = "${config.age.secrets.secrets.path}_nhamlh-passwd";
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
