{ config, lib, pkgs, pkgs-unstable, ... }:

let
in {
  imports = [
    ./emacs
    ./tmux
    ./zsh
    ./direnv.nix
    ./fzf.nix
    ./git.nix
    ./lang.nix
    ./starship.nix
  ];

  config = {
    home-manager.users.nhamlh = {
      home.packages = with pkgs; [
        (nerdfonts.override {
          fonts = [ "FiraCode" "DroidSansMono" "JetBrainsMono" ];
        })

        bottom # htop/zenith replacement
        doggo
        eza
        fd
        neovim
        ripgrep
        tmux
      ];

      programs.dircolors = {
        enable = true;
        enableZshIntegration = true;
      };

      programs.bat = {
        enable = true;
        config = { theme = "Solarized (light)"; };
      };

    };
  };
}
