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

    containers.enable = true;

    services = { grafana-agent.enable = true; };
    graphical = {
      enable = true;
      wm = "sway";
    };
    gaming = { steam.enable = true; };
  };

  system.stateVersion = "22.05"; # Did you read the comment?
}
