{ config, lib, pkgs, ... }:

with lib;
let cfg = config.my.modules.gui;
in {
  config = {
    home-manager.users.nhamlh = {
      programs.starship = {
        enable = true;
        settings = {
          add_newline = true;
          format = lib.concatStrings [
            "$username"
            "$hostname"
            "$directory"
            "$package"
            "$golang"
            "$python"
            "$nodejs"
            "$nix_shell"
            "$git_branch"
            "$git_commit"
            "$git_state"
            "$git_status"
            "$line_break"
            "$jobs"
            "$character"
          ];
          nix_shell.symbol = "❄️ ";
        };
      };
    };
  };
}
