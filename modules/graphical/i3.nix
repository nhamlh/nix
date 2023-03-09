{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.my.modules.graphical;
in {
  config = mkIf (cfg.enable && cfg.wm == "i3") {
    environment.systemPackages = with pkgs; [ dex xbindkeys ];

    services.xserver = {
      enable = true;
      autorun = true;
      videoDrivers = [ "amdgpu" ];
      dpi = 144;
      xkbOptions = "ctrl:swapcaps";
      autoRepeatDelay = 200;
      autoRepeatInterval = 50;

      libinput = {
        enable = true;

        touchpad = {
          naturalScrolling = true;
          disableWhileTyping = true;
        };
      };

      displayManager.sessionCommands = ''
        xbindkeys
        dex -a
      '';
    };

    services.xserver.windowManager.i3.enable = true;
    services.xserver.windowManager.i3.package = pkgs.i3-gaps;
    services.xserver.windowManager.i3.extraPackages = with pkgs; [
      i3status-rust
      i3lock
      rofi
    ];

    xdg.autostart.enable = true;

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.inputMethod = {
      enabled = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ bamboo ];
    };
  };
}
