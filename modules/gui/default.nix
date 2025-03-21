{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.my.modules.gui;
in {
  imports = [
    ./sway
    ./hyprland
    ./ghostty
    ./alacritty
    ./dunst
    ./rofi
    ./mpv.nix
    ./thunar.nix
    ./waybar.nix
  ];

  options.my.modules.gui = {
    enable = mkEnableOption "Graphical User Interface";
    wm = lib.mkOption {
      description = "Window manager to be used";
      default = "sway";
    };
  };

  config = mkIf cfg.enable {
    services.xserver.videoDrivers = [ "amdgpu" ];
    hardware.graphics.enable = true;

    services.dbus.enable = true;

    xdg = {
      autostart.enable = true;
      portal = {
        enable = true;
        wlr.enable = true;
      };
    };

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.addons = with pkgs; [ fcitx5-unikey fcitx5-mozc fcitx5-gtk ];
    };

    environment.systemPackages = with pkgs; [ telegram-desktop ];

    home-manager.users.nhamlh = {
      xdg.configFile.wallpapers.source = ../../wallpapers;

      home.packages = with pkgs; [
        nvtopPackages.full
        dex # generate and execute DesktopEntry files of the type Application
        imv
        # tdesktop
        zoom-us
        slack
        foliate # ebook reader

        # Browsers
        firefox
        chromium
        vivaldi
      ];
    };
  };
}
