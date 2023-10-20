{ config, lib, pkgs, ... }:

{
  imports = [
    ./git.nix
    ./zsh.nix
    ./fzf.nix
    ./tmux.nix
    ./direnv.nix
    ./emacs.nix
    ./starship.nix
  ];

  config = {
    home-manager.users.nhamlh = {
      home.packages = with pkgs; [
        (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })

        python3
        eza
        fd
        kubectl
        k9s
        yq
        ripgrep
        diff-so-fancy
        zenith
        usbutils
        unzip
        xclip
        awscli
        aws-mfa
        shellcheck
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
