{ config, lib, pkgs, pkgs-unstable, vscode-server, ... }:

with lib;
let
  cfg = config.my.modules.devbox;

  gdk = with pkgs-unstable;
    google-cloud-sdk.withExtraComponents
    (with pkgs-unstable.google-cloud-sdk.components;
      [ gke-gcloud-auth-plugin ]);
in {
  imports = [ ];

  options.my.modules.devbox = {
    enable = mkEnableOption "My development environment";
  };

  config = mkIf cfg.enable {
    home-manager.users.nhamlh = {

      # For remote-editing vscode
      imports = [ vscode-server.homeModules.default ];
      services.vscode-server.enable = true;

      home.packages = with pkgs-unstable; [
        gdk
        k9s
        kubectl
        aws-mfa
        awscli
        sqlite
        yq
        aider-chat
        aichat
        vscode
        code-cursor
      ];
    };

  };
}
