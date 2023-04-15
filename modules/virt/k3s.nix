{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.my.modules.containers.k3s;
  tokenFile = "${config.age.secrets.secrets.path}_k3s";
in {
  options.my.modules.containers.k3s = {
    enable = mkEnableOption "k3s";
    role = lib.mkOption {
      type = types.enum [ "server" "agent" ];
      default = "agent";
    };
    masterAddr = lib.mkOption { default = "https://localhost:6443"; };
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
        tokenFile = tokenFile;
        extraFlags = "--disable traefik --flannel-backend=wireguard-native";

      };
    })

    (mkIf (cfg.role == "agent") {
      services.k3s = {
        role = "agent";
        serverAddr = cfg.masterAddr;
        tokenFile = tokenFile;
        extraFlags = "";
      };
    })
  ]);
}
