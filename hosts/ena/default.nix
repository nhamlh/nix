{ config, pkgs, home-manager, ... }:

{
  imports = [ ./hardware.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "ena";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Ho_Chi_Minh";

  my.modules = {
    containers.k3s = {
      enable = true;
      role = "server";
    };

    services = {
      grafana-agent.enable = true;
      adguard.enable = true;
    };
  };

  system.stateVersion = "22.05";
}
