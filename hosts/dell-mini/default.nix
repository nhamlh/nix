{ config, pkgs, home-manager, ... }:

{
  imports = [ ./hardware.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "dell-mini";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Ho_Chi_Minh";

  my.modules = {
    containers.enable = true;

    services = {
      grafana-agent.enable = true;
      adguard.enable = true;
    };
  };

  system.stateVersion = "22.05";
}
