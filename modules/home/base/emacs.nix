{ config, lib, pkgs, ... }:

{
  config = {
    home-manager.users.nhamlh = {
      programs.emacs = {
        enable = true;
        extraPackages = epkgs: [ epkgs.vterm ];
      };

      xdg.configFile."doom".source = ./doom;
    };
  };
}
