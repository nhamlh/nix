{ pkgs, herdr, ... }: {
  home-manager.users.nhamlh = {
    home.packages = [ herdr.packages.${pkgs.system}.default ];

    xdg.configFile."herdr/config.toml".source = ./config.toml;
  };
}
