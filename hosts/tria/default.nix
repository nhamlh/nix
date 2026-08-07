{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "tria";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Ho_Chi_Minh";

  my.modules = {
    containers = {
      enable = true;
      k3s = {
        enable = false;
        role = "agent";
        masterAddr = "https://ena:6443";
      };
    };
  };

  # ZFS support.
  # Ref: https://openzfs.github.io/openzfs-docs/Getting%20Started/NixOS/index.html
  # Ref: https://nixos.wiki/wiki/ZFS
  networking.hostId = "677dda4e"; # head -c4 /dev/urandom | od -A none -t x4
  boot = {
    supportedFilesystems = [ "zfs" ];
    zfs.forceImportRoot = false;
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  };

  system.stateVersion = "24.05";
}
