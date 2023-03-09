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
}
