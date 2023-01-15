{ config, lib, pkgs, ... }:

{
  imports = [ ./git.nix ./zsh.nix ./tmux.nix ./direnv.nix ./emacs.nix ];

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
        fzf
        diff-so-fancy
        bat
        zenith
        usbutils
        unzip
        xclip
      ];
    };
  };
}
