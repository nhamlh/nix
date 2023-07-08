{ config, lib, pkgs, ... }:

{
  config = {
    home-manager.users.nhamlh = {
      programs.git = {
        enable = true;

        #TODO Derive from user info
        userName = "Nham Le";
        userEmail = "lehoainham@gmail.com";

        ignores = [ "*~" "*.swp" ".envrc" ".direnv" ".devenv" ];

        diff-so-fancy = { enable = true; };

        extraConfig = {
          init.defaultBranch = "main"; # based.
          core.editor = "nvim";
          credential.helper = "store --file ~/.git-credentials";
          pull.rebase = "false";
          # For supercede
          core.symlinks = true;

          # Sign all commits using ssh key
          commit.gpgsign = true;
          gpg.format = "ssh";
          user.signingkey = "~/.ssh/id_ed25519.pub";
        };
      };
    };
  };
}
