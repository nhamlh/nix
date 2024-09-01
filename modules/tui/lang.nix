{ config, lib, pkgs, ... }:

{

  home-manager.users.nhamlh = {
    home.packages = with pkgs; [
      python3
      poetry
      ruff

      yaml-language-server

      go
      gopls
      gomodifytags
      gotests
      gore

      nixfmt-rfc-style
      dockfmt

      shellcheck
      shfmt
    ];
  };
}
