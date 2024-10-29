{ config, lib, pkgs, ... }:

with lib;
let cfg = config.my.modules.devbox;
in {

  imports = [ ];

  options.my.modules.devbox = {
    enable = mkEnableOption "My development environment";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ aider-chat ]; };
}
