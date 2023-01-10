{ config, lib, pkgs, ... }:

{
  config = {
    home-manager.users.nhamlh = {
      home.file.".zshrc".source = ./zsh/zshrc;
      home.file.".zsh.d".source = ./zsh/zsh.d;
    };
  };
}
