{ options, config, lib, pkgs, ... }:

# Base module is enabled for all hosts, doesn't need to be flagged.

{
  imports = [
    ./packages.nix
    ./agenix.nix
    ./tailscale.nix
    ./services.nix
    ./console.nix
    ./users.nix
  ];

  config = { nix.settings.experimental-features = [ "nix-command" "flakes" ]; };
}
