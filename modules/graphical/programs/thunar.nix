# TODO: Convert to home-manager config
{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.my.modules.graphical.programs.thunar;
in {
  options.my.modules.graphical.programs.thunar = { enable = mkBoolOpt false; };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ xfce.thunar ];

    programs.thunar.plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];

    services.gvfs.enable = true; # Mount, trash, and other functionalities
    services.tumbler.enable = true; # Thumbnail support for images
  };
}
