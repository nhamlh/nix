{ config, lib, pkgs, ... }:

{
  config = {
    home-manager.users.nhamlh = {
      xdg.configFile."tmux/tmux.conf".source = ./tmux.conf; 
    };
  };
}
