{ config, lib, pkgs, ... }:

{
  config = {
    home-manager.users.nhamlh = {
      programs.tmux = {
        enable = true;
        clock24 = true;
        # TODO other optoins

      };
      xdg.configFile."tmux/tmux.conf".source = ./tmux.conf;
    };
  };
}
