{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.my.modules.graphical;
in {
  imports = [ ./i3.nix ./sway.nix ];

  options.my.modules.graphical = {
    enable = mkEnableOption "Graphical module";
    # TODO Implement i3 submodule
    wm = lib.mkOption {
      description = "Window manager to be used";
      default = "i3";
    };
  };

  config = mkIf cfg.enable {
    services.dbus.enable = true;

    xdg = {
      autostart.enable = true;

      portal = {
        enable = true;
        wlr.enable = true;
        # gtk portal needed to make gtk apps happy
        extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
      };
    };

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [ fcitx5-unikey ];
    };
  };
}
