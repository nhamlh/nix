{ options, config, lib, pkgs, ... }:

with lib; {
  config = {
    environment.systemPackages = with pkgs; [
      gnumake
      gcc
      zsh
      git
      curl
      wget
      tmux
      neovim
      unzip
    ];
  };
}
