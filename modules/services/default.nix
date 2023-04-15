{ config, lib, pkgs, ... }:

{
  imports = [ ./grafana-agent.nix ./adguard.nix ];
}
