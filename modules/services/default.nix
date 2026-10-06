{ config, lib, pkgs, ... }:

{
  imports = [ ./adguard.nix ./cloudflare-warp.nix ];
}
