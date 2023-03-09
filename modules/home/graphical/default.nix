{ config, lib, pkgs, ... }:

with lib;
let cfg = config.my.modules.graphical;
in {

  imports = [
    ./packages.nix
    ./i3.nix
    ./sway.nix
    ./thunar.nix
    ./rofi.nix
    ./alacritty.nix
    ./mpv.nix
  ];

  config = mkIf cfg.enable {
    home-manager.users.nhamlh = {
      xdg.configFile."compton.conf".source = ./compton.conf;
      home.file.".xbindkeysrc".source = ./xbindkeysrc;
      home.file.".Xresources".source = ./Xresources;
    };
  };
}
