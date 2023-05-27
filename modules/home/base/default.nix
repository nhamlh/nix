{ config, lib, pkgs, ... }:

{
  imports =
    [ ./git.nix ./zsh.nix ./fzf.nix ./tmux.nix ./direnv.nix ./emacs.nix ];

  config = {
    home-manager.users.nhamlh = {
      home.packages = with pkgs; [
        (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })

        python3
        exa
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
