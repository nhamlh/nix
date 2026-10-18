{ pkgs, pi, ... }: {
  home-manager.users.nhamlh.home.packages = [ pi.packages.${pkgs.stdenv.hostPlatform.system}.default ];
}
