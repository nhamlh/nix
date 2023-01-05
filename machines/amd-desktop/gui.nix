{ config, lib, pkgs, ... }:

{
  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    autorun = true;
    videoDrivers = ["amdgpu"];
    dpi = 144;
    xkbOptions = "ctrl:swapcaps";
    #autoRepeatDelay = 200;
    #autoRepeatInterval = 50;

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
  services.xserver.windowManager.i3.extraPackages = with pkgs; [i3status-rust i3lock rofi];

  xdg.autostart.enable = true;

}
