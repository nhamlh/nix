{ options, config, lib, pkgs, agenix, ... }:

with lib;
let cfg = config.my.modules.base.agenix;
in {

  imports = [ agenix.nixosModule ];

  options.my.modules.base.agenix = {
    enable = mkEnableOption "Age files encrypting";
  };

  config = {
    environment.systemPackages = with pkgs;
      [ agenix.defaultPackage.x86_64-linux ];

    age = {
      identityPaths = [ "${config.users.users.nhamlh.home}/.ssh/id_ed25519" ];
      secrets.tskey.file = ../../secrets/tskey.age;
      # Grafana Agent API keys
      secrets.ga-prom-key.file = ../../secrets/ga-prom-key.age;
      secrets.ga-loki-key.file = ../../secrets/ga-loki-key.age;
    };
  };
}
