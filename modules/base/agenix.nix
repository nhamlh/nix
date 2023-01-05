{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.my.modules.base.agenix;
in {

  options.my.modules.base.agenix = { enable = mkBoolOpt true; };

  config = mkIf cfg.enable {
    #FIXME: Append agenix to pkgs, otherwise this will fail
    environment.systemPackages = with pkgs;
      [ agenix.defaultPackage.x86_64-linux ];

    age = {
      identityPaths = [ "${config.users.users.nhamlh.home}/.ssh/id_ed25519" ];
      secrets.tskey.file = ./secrets/tskey.age;
    };
  };
}
