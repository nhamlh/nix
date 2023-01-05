{ options, config, lib, pkgs, agenix, ... }:

with lib;
let cfg = config.my.modules.base.agenix;
in {

  options.my.modules.base.agenix = {
    enable = mkEnableOption "Age files encrypting";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      [ agenix.defaultPackage.x86_64-linux ];

    age = {
      identityPaths = [ "${config.users.users.nhamlh.home}/.ssh/id_ed25519" ];
      secrets.tskey.file = ../../secrets/tskey.age;
    };
  };
}
