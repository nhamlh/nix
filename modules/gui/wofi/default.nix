{ config, lib, pkgs, ... }:

with lib;
let cfg = config.my.modules.gui;
in {
  config = mkIf (cfg.enable && cfg.wm == "sway") {
    home-manager.users.nhamlh = {
      home.packages = with pkgs; [ wofi ];

      xdg.configFile."wofi/config".text = ''
        width=600
        height=400
        mode=drun
        filter_rate=100
        allow_markup=true
        no_actions=true
        halign=fill
        orientation=vertical
        content_halign=fill
        insensitive=true
        allow_images=true
        image_size=24
        gtk_dark=true
        term=ghostty
      '';

      xdg.configFile."wofi/style.css".source = ./style.css;
    };
  };
}
