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
      # This one file is a nix expression to host all secrets
      secrets.secrets.file = "${secrets}/secrets.age";
    };
  };
}
