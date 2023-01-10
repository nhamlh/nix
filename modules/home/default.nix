{ config, lib, pkgs, home-manager, ... }:

let hm = home-manager.nixosModules.home-manager;
in {
  imports = [ hm { } ./base ./graphical ];

  config = {
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
