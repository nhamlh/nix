{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.my.modules.base.packages;
in {
  options.my.modules.base.packages = {
    enable = mkEnableOption "Install base packages";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gnumake
      gcc
      zsh
      git
      curl
      wget
      tmux

      #TODO: break out of base packages
      neovim
      python3
      unzip
    ];
  };
}
