{ config, lib, pkgs, ... }:

with lib;
let cfg = config.my.modules.graphical;
in {

  imports = [
    ./alacritty
    ./dunst
    ./hyprland
    ./i3
    ./rofi
    ./sway
    ./mpv.nix
    ./thunar.nix
    ./waybar.nix
  ];

  config = mkIf cfg.enable {
    home-manager.users.nhamlh = {
      xdg.configFile.wallpapers.source = ../../../wallpapers;

      home.packages = with pkgs; [
        nvtop
        dex # generate and execute DesktopEntry files of the type Application
        imv
        firefox
        chromium
        tdesktop
        zoom-us
        drawio
        slack
        foliate # ebook reader
        kitty
        thunderbird
      ];
    };
  };
}
