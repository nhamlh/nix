{ config, lib, pkgs, ... }:

with lib;
let cfg = config.my.modules.graphical;
in {

  imports = [
    ./packages.nix
    ./i3.nix
    ./sway.nix
    ./dunst.nix
    ./thunar.nix
    ./rofi.nix
    ./alacritty.nix
    ./mpv.nix
  ];

  config = mkIf cfg.enable {
    home-manager.users.nhamlh = {
      xdg.configFile."wallpapers".source = ../../../wallpapers;
    };
  };
}
