{ options, config, lib, pkgs, ... }:

with lib; {
  config = {
    console = {
      useXkbConfig = true; # use xkbOptions in tty.
    };
  };
}
