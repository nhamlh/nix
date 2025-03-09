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
    };

    services = {
      grafana-agent.enable = false;
      cloudflare-warp.enable = false;
    };

    containers.enable = true;

    gui = {
      enable = true;
      wm = "sway";
    };
    gaming = { steam.enable = true; };
    devbox.enable = true;
  };

  # ZFS support.
  # Ref: https://openzfs.github.io/openzfs-docs/Getting%20Started/NixOS/index.html
  # Ref: https://nixos.wiki/wiki/ZFS
  networking.hostId = "ba719b2f"; # head -c4 /dev/urandom | od -A none -t x4
  boot = {
    supportedFilesystems = [ "zfs" ];
    zfs.forceImportRoot = false;
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  };

  system.stateVersion = "22.05"; # Did you read the comment?
}
