{ config, lib, pkgs, ... }:

{
  config = { xdg.configFile."tmux/tmux.conf".source = ./tmux.conf; };
}
