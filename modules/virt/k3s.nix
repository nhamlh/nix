{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.my.modules.containers.k3s;
  agent-token = "efc54df42b945feb3ad7829395e77054";
in {
  options.my.modules.containers.k3s = {
    enable = mkEnableOption "k3s";
    role = lib.mkOption {
      description = "Window manager to be used";
      #FIXME: only agent or server is allowed
      default = "agent";
    };

    agent = { enabled = true; };
  };

  config = mkIf cfg.enable (mkMerge [
    {

      networking.firewall.allowedTCPPorts = [
        6443 # This is required so that pod can reach the API server (running on port 6443 by default)
        10250 # Allow healthcheck
      ];
      services.k3s.enable = true;
      environment.systemPackages = [ pkgs.k3s ];

    }

    (mkIf (cfg.role == "server") {
      services.k3s = {
        role = "server";
        token = agent-token;
        extraFlags = "--disable traefik --flannel-backend=wireguard-native";

      };
    })

    (mkIf (cfg.role == "agent") {
      services.k3s = {
        role = "agent";
        serverAddr = lib.mkDefault "https://${TODO}:6443";
        token = agent-token;
        extraFlags = "--flannel-backend=wireguard-native";
      };
    })
  ]);
}
