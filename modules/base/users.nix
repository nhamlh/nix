{ config, lib, pkgs, home-manager, ... }:

let
  hm = home-manager.nixosModules.home-manager;
  secrets = config.age.secrets.secrets.path;
  user = "nhamlh";
in with lib; {
  config = {
    users = {
      # Ref: https://nixos.org/manual/nixos/stable/options.html#opt-users.mutableUsers
      # NOTE: Set to false maybe? If so, we need to deal with storing user
      # password in git (encrypted using agenix) and password rotating. Seprate
      # these sensitive things (password, API keys, etc) into private git repo
      # as a flake can be considered secure enough
      mutableUsers = false;
      defaultUserShell = pkgs.zsh;

      users.nhamlh = {
        isNormalUser = true;
        extraGroups = [ "wheel" "docker" ];
        home = "/home/${user}";
        hashedPasswordFile =
          "${config.age.secrets.secrets.path}_${user}-passwd";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKmPhGYUluyUQ2j/pcF+2hyC38HBMnkyPYd3Mq3IlI8d nhamlh@somewhereonearth"
        ];
      };
    };

    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;

    home-manager.users.nhamlh = {
      home.username = user;
      home.homeDirectory = "/home/${user}";

      home.stateVersion = "22.05";
      programs.home-manager.enable = true;
    };
  };
}
