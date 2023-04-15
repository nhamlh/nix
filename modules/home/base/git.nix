{ config, lib, pkgs, ... }:

{
  config = {
    home-manager.users.nhamlh = {
      programs.git = {
        enable = true;

        #TODO Derive from user info
        userName = "Nham Le";
        userEmail = "lehoainham@gmail.com";

        ignores = [ "*~" "*.swp" ];

        diff-so-fancy = { enable = true; };

        extraConfig = {
          init.defaultBranch = "master"; # based.
          core.editor = "nvim";
          credential.helper = "store --file ~/.git-credentials";
          pull.rebase = "false";
          # For supercede
          core.symlinks = true;
        };
      };
    };
  };
}
