{ config, pkgs, home-manager, ... }:

{
  imports = [ ./hardware.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "lenovo-m900";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Ho_Chi_Minh";

  my.modules = {
    containers.k3s = {
      enable = true;
      role = "server";
      #masterAddr = "https://dell-mini:6443";
    };

    services = { grafana-agent.enable = true; };
  };

  system.stateVersion = "22.05";
}
