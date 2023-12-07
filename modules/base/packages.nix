{ options, config, lib, pkgs, ... }:

with lib; {
  config = {
    environment.systemPackages = with pkgs; [
      nfs-utils
      gnumake
      glibc
      gcc
      openssl
      zsh
      bash
      git
      curl
      wget
      tmux
      neovim
      unzip
      dig
      pwgen
      lm_sensors
      tree
      file
      unzip
    ];
  };
}
