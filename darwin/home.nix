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
      vi = "nvim"; python = "python3";
    };
    sessionVariables = { EDITOR = "nvim"; };
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
