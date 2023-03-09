{ options, config, lib, pkgs, agenix, secrets, ... }:

with lib;
let cfg = config.my.modules.base.agenix;
in {

  imports = [ agenix.nixosModules.default ];

  options.my.modules.base.agenix = {
    enable = mkEnableOption "Age files encrypting";
  };

  config = {
    environment.systemPackages = with pkgs;
      [ agenix.packages.x86_64-linux.default ];

    age = {
      identityPaths = [ "${config.users.users.nhamlh.home}/.ssh/id_ed25519" ];

      #TODO: Map over secrets and populate age files
      #secrets.nhamlh-passwd.file = "${secrets}/nhamlh-passwd.age";
      #secrets.tskey.file = "${secrets}/tskey.age";
      #secrets.ga-prom-key.file = "${secrets}/ga-prom-key.age";
      #secrets.ga-loki-key.file = "${secrets}/ga-loki-key.age";
    };
  };
}
