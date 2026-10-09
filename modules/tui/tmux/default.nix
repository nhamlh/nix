{ config, lib, pkgs, ... }:

let
  # Not in nixpkgs. Replace lib.fakeHash with the hash nix reports on first build.
  fromGitHub = owner: repo: pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = repo;
    version = "unstable";
    src = pkgs.fetchFromGitHub {
      inherit owner repo;
      rev = "HEAD"; # ponytail: pin a commit for reproducibility
      hash = lib.fakeHash;
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
          (fromGitHub "erikw" "tmux-powerline")
          {
            plugin = fromGitHub "jtbairdsr" "tmux-inactive-panes";
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
