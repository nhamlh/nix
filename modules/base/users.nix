{ options, config, lib, pkgs, ... }:

with lib; {
  config = {
    users = {
      # Ref: https://nixos.org/manual/nixos/stable/options.html#opt-users.mutableUsers
      # NOTE: Set to false maybe? If so, we need to deal with storing user
      # password in git (encrypted using agenix) and password rotating. Seprate
      # these sensitive things (password, API keys, etc) into private git repo
      # as a flake can be considered secure enough
      mutableUsers = true;
      defaultUserShell = pkgs.zsh;
    };
  };
}
