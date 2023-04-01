{ options, config, lib, pkgs, agenix, secrets, ... }:

with lib;
let
  cfg = config.my.modules.base.agenix;
  secretsPath = config.age.secrets.secrets.path;
  jsonToFiles = ''
    echo "[secrets] splitting secrets to its own files..."

    jq=${pkgs.jq}/bin/jq

    $jq -c '.[]' ${secretsPath} | while read i; do
       filename=$(echo $i | $jq -r '.name')
       secret=$(echo $i | $jq -r '.secret')

       echo "[secrets] splitting $filename..."
       echo $secret > ${secretsPath}_$filename
    done
  '';
in {

  imports = [ agenix.nixosModules.default ];

  config = {
    environment.systemPackages = with pkgs;
      [ agenix.packages.x86_64-linux.default ];

    age = {
      identityPaths = [ "${config.users.users.nhamlh.home}/.ssh/id_ed25519" ];
      # This one file is a nix expression to host all secrets
      secrets.secrets.file = "${secrets}/secrets.age";
    };

    # Before nix needs to evaluate the secret file at build time to get its
    # content which is too soon that agenix hadn't kicked in with its activation
    # script yet. Now we parse the json content to files right after the agenix,
    # which contain only one secret, and delay reading actually secret to
    # runtime, meaning applications that need a secret will need to read its
    # own. We should only provide it the secret path.
    system.activationScripts.jsonToFiles = {
      text = jsonToFiles;

      # agenix's activation script
      deps = [ "agenixInstall" ];
    };

    # So user passwords can be encrypted.
    system.activationScripts.users.deps = [ "jsonToFiles" ];
  };
}
