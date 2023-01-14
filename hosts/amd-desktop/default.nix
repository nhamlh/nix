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
      hidpi.enable = true;
    };

    containers.enable = true;

    services = { grafana-agent.enable = true; };

    graphical = {
      enable = true;
      #programs = { thunar.enable = true; };
      programs = { test.enable = true; };
    };

    gaming = { steam.enable = true; };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nhamlh = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    home = "/home/nhamlh";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKmPhGYUluyUQ2j/pcF+2hyC38HBMnkyPYd3Mq3IlI8d nhamlh@somewhereonearth"
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}

