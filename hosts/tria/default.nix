{ config, lib, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "tria";
  networking.networkmanager.enable = true;

  Time.timeZone = "Asia/Ho_Chi_Minh";

  my.modules = {
    containers.k3s = {
      enable = true;
      role = "agent";
      masterAddr = "https://ena:6443";
    };
  };

  system.stateVersion = "24.05";
}
