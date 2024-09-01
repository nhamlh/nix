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
          source = (fetchurl v);
        }) {
          "copy-time.lua" =
            "https://raw.githubusercontent.com/Arieleg/mpv-copyTime/master/copyTime.lua";
        };
    };
  };
}
