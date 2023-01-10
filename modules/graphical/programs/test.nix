# TODO: Convert to home-manager config
{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.my.modules.graphical.programs.thunar;
in {
  options.my.modules.graphical.programs.test = {
    enable = mkEnableOption "test home-manager config";
  };
}
