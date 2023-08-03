{ config, lib, pkgs, ... }:

{
  config = {
    home-manager.users.nhamlh = {
      #TODO: setup doomemacs properly according to https://github.com/doomemacs/doomemacs/blob/master/docs/getting_started.org#doom-emacs
      programs.emacs = {
        enable = true;
        package = pkgs.emacs29;
        extraPackages = epkgs: [ epkgs.vterm ];
      };

      #TODO: Set DOOMDIR to "xdg.configFile.doom"
      home.file.".doom.d".source = ./doom;
    };
  };
}
