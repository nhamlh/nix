{ config, lib, pkgs, ... }:

let
  # Not in nixpkgs; pinned by commit.
  fromGitHub = owner: repo: rev: hash: pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = repo;
    version = "unstable";
    src = pkgs.fetchFromGitHub {
      inherit owner repo;
      inherit rev hash;
    };
  };
in {
  config = {
    home-manager.users.nhamlh = {
      programs.tmux = {
        enable = true;
        clock24 = true;
        extraConfig = builtins.readFile ./tmux.conf;
        plugins = with pkgs.tmuxPlugins; [
          yank
          {
            plugin = open;
            extraConfig = ''
              set -g @open-editor 'O'
              set -g @open-S 'https://www.google.com/'
            '';
          }
          (fromGitHub "erikw" "tmux-powerline" "67e21efaeb560443c741e240b74ce7f3995c765d" "sha256-gdJ/cZfCByLlf5qnjcODuITZMCUtSFxXMo4tvoeuBto=")
          {
            plugin = fromGitHub "jtbairdsr" "tmux-inactive-panes" "60018a5f437d13cf4990838c5b1bd17048db0979" "sha256-CvW7FXbQlLkYEzQpLp6Y5fKFizD9XK6sko6Qppz1zDM=";
            extraConfig = ''
              set -g @default-inactive-color 'dark'
              set -g @active-fg-color-dark colour2
            '';
          }
          {
            plugin = resurrect;
            extraConfig = "set -g @resurrect-strategy-nvim 'session'";
          }
        ];
      };
    };
  };
}
