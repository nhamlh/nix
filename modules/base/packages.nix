{ options, config, lib, pkgs, ... }:

with lib; {
  config = {
    environment.systemPackages = with pkgs; [
      gnumake
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
    ];
  };
}
