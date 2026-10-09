{ pkgs, ... }:

{
  home.stateVersion = "26.05";

  # Moved from brew leaves. Names verified against nixpkgs only after first build.
  home.packages = with pkgs; [
    act age awscli2 binaryen bottom cloud-sql-proxy cmake coreutils
    doggo duckdb eza fd flatbuffers geos gh git-filter-repo gleam glow
    gnu-sed gnu-tar go gopls grpcurl hcloud helix imagemagick jq just
    k9s kubectl kubernetes-helm lazygit lefthook llvm maven mkcert mosh
    neovim nushell pandoc percona-toolkit pnpm pwgen ripgrep ruff
    rustc cargo s3cmd skopeo socat sops stern swaks terminal-notifier
    terragrunt trivy uv vegeta websocat yamllint yq-go zellij zig
    mpv tmux
  ];

  programs.zsh = {
    enable = true;
    defaultKeymap = "emacs";
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history = {
      size = 10000;
      save = 15000;
      extended = true;
      ignoreDups = true;
      expireDuplicates = true;
      share = true;
    };
    shellAliases = {
      cat = "bat"; d = "doggo"; dc = "docker-compose"; df = "df -h"; du = "du -h";
      kns = "kubens"; ktx = "kubectx"; tf = "terraform"; tg = "terragrunt";
      vi = "nvim"; python = "python3"; k9s = "sofka";
    };
    sessionVariables = {
      EDITOR = "nvim";
      GOOGLE_APPLICATION_CREDENTIALS = "$HOME/.config/gcloud/application_default_credentials.json";
      GOOGLE_CLOUD_PROJECT = "tevi-app-prod";
      GOOGLE_CLOUD_LOCATION = "global";
      VERTEX_LOCATION = "global";
      VERTEXAI_PROJECT = "tevi-app-prod";
      VERTEXAI_LOCATION = "global";
      NODE_EXTRA_CA_CERTS = "$HOME/Library/Application Support/mkcert/rootCA.pem";
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
    ];
    initContent = ''
      [[ -f "$HOME/.envs" ]] && source "$HOME/.envs"
      export PATH="$HOME/.local/bin:$HOME/.bun/bin:$HOME/.krew/bin:$PATH"
      bindkey '\C-h' backward-delete-word
      bindkey '\C-x\C-e' edit-command-line
      autoload -U edit-command-line && zle -N edit-command-line
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'
      zstyle ':completion:*' menu select
      setopt interactivecomments
      WORDCHARS="''${WORDCHARS:s@/@}"
      [[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

      # List local branches whose patches are all already in main (safe to delete)
      git-branches-merged() {
        local base=''${1:-main} b cherry
        for b in $(git branch | grep -v '^\*' | grep -v 'worktree/' | sed 's/^[+ ]*//'); do
          cherry=$(git cherry "$base" "$b" 2>/dev/null)
          if [ -n "$cherry" ] && ! echo "$cherry" | grep -q '^+'; then
            echo "$b"
          fi
        done
      }

      # cd to git project root
      cdpr() {
        local dir=$PWD
        while [[ $dir != / ]]; do
          [[ -d $dir/.git ]] && cd $dir && return
          dir=''${dir:h}
        done
        echo "No git repo found"
      }
    '';
  };
  programs.starship.enable = true;
  programs.fzf.enable = true;
  programs.bat.enable = true;
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user = {
        name = "ntvcom";
        email = "nham@tevi.com";
        signingkey = "~/.ssh/id_ed25519.pub";
      };
      init.defaultBranch = "main";
      core.editor = "nvim";
      core.symlinks = true;
      pull.rebase = true;
      commit.gpgsign = true;
      gpg.format = "ssh";
      credential.helper = "store --file ~/.git-credentials";
      "credential \"https://github.com\"".helper = [ "" "!gh auth git-credential" ];
      "credential \"https://gist.github.com\"".helper = [ "" "!gh auth git-credential" ];
      "url \"ssh://git@gitlab.tevi.dev\"".insteadOf = "https://gitlab.tevi.dev";
      "includeIf \"gitdir:~/projects/tevi/\"".path = "~/projects/tevi/.gitconfig";
    };
  };
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = { light = true; side-by-side = true; };
  };
  programs.direnv = { enable = true; nix-direnv.enable = true; };
}
