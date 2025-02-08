{ config, lib, pkgs, pkgs-unstable, ... }:

with lib;
let cfg = config.my.modules.devbox;

in {

  imports = [ ];

  options.my.modules.devbox = {
    enable = mkEnableOption "My development environment";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs-unstable; [
      aider-chat
      aichat
      vscode
    ];
  };
}
