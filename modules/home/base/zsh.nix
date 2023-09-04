{ config, lib, pkgs, ... }:

let profiling = false;
in {
  config = {
    home-manager.users.nhamlh = {
      home.file.".zsh.d".source = ./zsh/zsh.d;

      programs.zsh = {
        enable = true;
        defaultKeymap = "emacs";
        #FIXME: this flag is causing perf issue so I need to disable for now
        enableCompletion = false;

        history = {
          expireDuplicatesFirst = true;
          extended = true;
          ignoreDups = true;
          ignoreSpace = false;
          save = 15000;
          share = true;
        };

        sessionVariables = {
          TERM = "xterm-256color";

          ZSH_PLUGINS_ALIAS_TIPS_TEXT = "💡 Alias tip: ";
          ZSH_PLUGINS_ALIAS_TIPS_FORCE = 1;
          ZSH_PLUGINS_ALIAS_TIPS_EXPAND = 1;

          EDITOR = "nvim";
          WORDCHARS = ""; # Make M-f and M-b work better for me
          EXTENDEDGLOB = 1; # globbing
          ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=10";
        };

        initExtraFirst = lib.optionalString profiling "zmodload zsh/zprof" + ''
          # Load my custom environment variales
          if [[ -f "$HOME/.envs" ]] then
            source $HOME/.envs
          fi

          # /etc/zshrc defined this alias which clashes with zpm-zsh/ls plugin
          unalias ls
        '';

        initExtra = ''
          bindkey '\C-h' backward-delete-word

          # Edit the current command line in $EDITOR
          autoload -U edit-command-line
          zle -N edit-command-line
          bindkey '\C-x\C-e' edit-command-line

          # Edit the current command line in $EDITOR
          autoload -U edit-command-line && zle -N edit-command-line
          bindkey '\C-x\C-e' edit-command-line

          zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'
          zstyle ':completion:*' menu select
          setopt interactivecomments
        '' + lib.optionalString profiling "zprof";

        shellAliases = {
          vi = "nvim";
          cat = "bat";
          du = "du -h";
          df = "df -h";
          dig = "dig +short";
          tf = "terraform";
          tg = "terragrunt";
          ktx = "kubectx";
          kns = "kubens";
          dc = "docker-compose";
          kgpc =
            "kubectl get pod -o=custom-columns='NAME:.metadata.name,STATUS:.status.phase,IP:.status.podIP,NODE:.status.hostIP'";
          sd = "sudo systemctl";
          git_current_branch =
            "git symbolic-ref -q HEAD | sed -e 's|^refs/heads/||'";
        };

        plugins = [
          {
            name = "alias-tips";
            src = pkgs.fetchFromGitHub {
              owner = "djui";
              repo = "alias-tips";
              rev = "41cb143ccc3b8cc444bf20257276cb43275f65c4";
              sha256 = "ZFWrwcwwwSYP5d8k7Lr/hL3WKAZmgn51Q9hYL3bq9vE=";
            };
          }
          {
            name = "solarized-man";
            src = pkgs.fetchFromGitHub {
              owner = "zlsun";
              repo = "solarized-man";
              rev = "e69d2cedc3a51031e660f2c3459b08ab62ef9afa";
              sha256 = "qDenIGAfqdT8NZPWF6QupPhBeNKiWlC/k0ZE+F3HVtI=";
            };
          }
          {
            name = "zsh-dircolors-solarized";
            src = pkgs.fetchFromGitHub {
              owner = "joel-porquet";
              repo = "zsh-dircolors-solarized";
              rev = "6f6fafee27e1d379c46b8c46775bccd1133b43d6";
              sha256 = "/fyUwKukph0mhNfanq7hj+67gurUXv5V9rGVws9wFGg=";
            };
          }
          {
            name = "ls";
            src = pkgs.fetchFromGitHub {
              owner = "zpm-zsh";
              repo = "ls";
              rev = "2db52bcab188b161d71df04c1265646be8f2dda4";
              sha256 = "4Tuc5N14xKx5ArQAoIovn4eXAVKHoFxnfE0A0eG67GM=";
            };
          }
          {
            name = "zsh-autopair";
            src = pkgs.fetchFromGitHub {
              owner = "hlissner";
              repo = "zsh-autopair";
              rev = "396c38a7468458ba29011f2ad4112e4fd35f78e6";
              sha256 = "PXHxPxFeoYXYMOC29YQKDdMnqTO0toyA7eJTSCV6PGE=";
            };
          }
          {
            name = "git-aliases";
            file = "git-aliases.zsh";
            src = pkgs.fetchFromGitHub {
              owner = "mdumitru";
              repo = "git-aliases";
              rev = "c4cfe2cf5cf59a3da6bf3b735a20921a2c06c58d";
              sha256 = "640qGgVeFaTIQBgYGY05/4wzMCxni0uWLWtByEFM2tE=";
            };
          }
          {
            name = "git-prune";
            src = pkgs.fetchFromGitHub {
              owner = "Seinh";
              repo = "git-prune";
              rev = "b2483946b130da45441099bde0bd290bc40afdf5";
              sha256 = "zTKZ1xyLxNfBlme4IvunjKZ5F4WxBKM3n/sCiK7tLpw=";
            };
          }
          {
            name = "gitignore.plugin.zsh";
            src = pkgs.fetchFromGitHub {
              owner = "voronkovich";
              repo = "gitignore.plugin.zsh";
              rev = "d79419519c2466b37d532636e2cea7bcdb3cf084";
              sha256 = "ein4MHmzmIRfLjEdm84dqi19zWJ6K83CW7ux8mh5BQI=";
            };
          }
          {
            name = "docker-aliases";
            src = pkgs.fetchFromGitHub {
              owner = "webyneter";
              repo = "docker-aliases";
              rev = "e0752d29803a238a799fca416c43d40dca485f3d";
              sha256 = "Lh+JtPYRY6GraIBnal9MqWGxhJ4+b6aowSDJkTl1wVE=";
            };
          }
          {
            name = "kubectl-aliases";
            file = ".kubectl_aliases";
            src = pkgs.fetchFromGitHub {
              owner = "ahmetb";
              repo = "kubectl-aliases";
              rev = "b2ee5dbd3d03717a596d69ee3f6dc6de8b140128";
              sha256 = "TCk26Wdo35uKyTjcpFLHl5StQOOmOXHuMq4L13EPp0U=";
            };
          }
          {
            name = "zsh-autosuggestions";
            src = pkgs.fetchFromGitHub {
              owner = "zsh-users";
              repo = "zsh-autosuggestions";
              rev = "a411ef3e0992d4839f0732ebeb9823024afaaaa8";
              sha256 = "KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w=";
            };
          }
          {
            name = "fast-syntax-highlighting";
            src = pkgs.fetchFromGitHub {
              owner = "zdharma-continuum";
              repo = "fast-syntax-highlighting";
              rev = "13d7b4e63468307b6dcb2dadf6150818f242cbff";
              sha256 = "AmsexwVombgVmRvl4O9Kd/WbnVJHPTXETxBv18PDHz4=";
            };
          }
        ];
      };
    };
  };
}
