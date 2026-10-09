{ pkgs, ... }:

{
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = 6;
  system.primaryUser = "nham";

  users.users.nham.home = "/Users/nham";
  programs.zsh.enable = true;

  # Touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  # GUI apps, and formulae better left to brew (services, odd taps).
  # cleanup = "none" so first switch does not remove what is not listed yet.
  # Once happy, change to "zap" to drop everything undeclared.
  homebrew = {
    enable = true;
    onActivation.cleanup = "none";
    taps = [
      "d12frosted/emacs-plus"
      "nklmilojevic/sofka"
      "yvgude/lean-ctx"
    ];
    brews = [
      "d12frosted/emacs-plus/emacs-plus@30"
      "nklmilojevic/sofka/sofka"
      "yvgude/lean-ctx/lean-ctx"
      "herdr" "rtk" "zeroclaw" "beads" "agent-browser" "openspec"
      "mcp-toolbox" "claude-code-router" "prek" "egctl" "tf-summarize"
      "podman" "postgresql@14" "mysql" "ghcup" "zig@0.15"
    ];
    casks = [
      "bruno" "claude-code" "clickhouse" "codexbar" "container-use"
      "finetune" "flutter" "gcloud-cli" "ghostty" "github" "neomacs"
      "ngrok" "opencode-desktop" "orbstack" "sbx" "tailscale-app"
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.nham = import ./home.nix;
  };
}
