{ config, lib, pkgs, ... }:

let

  gdk = pkgs.google-cloud-sdk.withExtraComponents
    (with pkgs.google-cloud-sdk.components; [ gke-gcloud-auth-plugin ]);
in {
  imports = [
    ./lang.nix
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
        (nerdfonts.override {
          fonts = [ "FiraCode" "DroidSansMono" "JetBrainsMono" ];
        })

        eza
        fd
        kubectl
        k9s
        yq
        ripgrep
        diff-so-fancy
        bottom # htop/zenith replacement
        usbutils
        xclip
        awscli
        aws-mfa
        gdk
        sqlite
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
