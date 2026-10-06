{ config, lib, pkgs, ... }:

with builtins;
with lib;
let cfg = config.my.modules.gui;
in {
  config = mkIf cfg.enable {
    home-manager.users.nhamlh = {
      home.packages = with pkgs; [ mpv ];
      xdg.configFile = mapAttrs' (k: v:
        lib.attrsets.nameValuePair "mpv/scripts/${k}" {
          source = pkgs.fetchurl v;
        }) {
          "copy-time.lua" = {
            url =
              "https://raw.githubusercontent.com/Arieleg/mpv-copyTime/10b53d507085ba2deda301b6fab3397eee275b71/copyTime.lua";
            hash = "sha256-HJEGX18LHGZ8QlNKnJtdIp30314koBEtbSzZbd21KK4=";
          };
        };
    };
  };
}
