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

  programs.zsh.enable = true;
  programs.starship.enable = true;
  programs.fzf.enable = true;
  programs.bat.enable = true;
  programs.git = {
    enable = true;
    settings.user = { name = "nhamlh"; email = "CHANGE_ME"; };
  };
  programs.delta = { enable = true; enableGitIntegration = true; };
  programs.direnv = { enable = true; nix-direnv.enable = true; };
}
