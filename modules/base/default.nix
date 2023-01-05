{ options, config, lib, pkgs, ... }:

{
  imports = [ ./packages.nix ./agenix.nix ./tailscale.nix ./services.nix ];

}
