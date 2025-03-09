{ options, config, lib, pkgs, ... }:

with lib; {
  config = {
    environment.systemPackages = with pkgs; [
      xclip
      bash
      cmake
      curl
      file
      gcc
      glibc
      gnumake
      lm_sensors
      nfs-utils
      openssl
      pwgen
      tree
      unzip
      usbutils
      wget
      zsh
    ];
  };
}
