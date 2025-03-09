{ config, lib, pkgs, pkgs-unstable, ... }:

with lib;
let cfg = config.my.modules.devbox;

in {

  imports = [ ];

  options.my.modules.devbox = {
    enable = mkEnableOption "My development environment";
  };

  config = mkIf cfg.enable {
    home-manager.users.nhamlh = {

      # For remote-editing vscode
      imports = [
        "${
          fetchTarball
          "https://github.com/msteen/nixos-vscode-server/tarball/master"
        }/modules/vscode-server/home.nix"
      ];
      services.vscode-server.enable = true;

      home.packages = with pkgs-unstable; [
        aider-chat
        aichat
        vscode
        code-cursor
      ];
    };

  };
}
