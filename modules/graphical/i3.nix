{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.my.modules.graphical;
in {
  config = mkIf (cfg.enable && cfg.wm == "i3") {
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
    };
  };
}
