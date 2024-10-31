{
  system ? builtins.currentSystem,
  pkgs ? import <nixpkgs> { inherit system; },
}:

with pkgs;
let
  nixBin = writeShellScriptBin "nix" ''
    ${nixVersions.stable}/bin/nix --option experimental-features "nix-command flakes" "$@"
  '';
in
mkShell {
  inherit system;
  buildInputs = [ nixfmt-classic ];
  shellHook = ''
    export FLAKE="$(pwd)"
    export PATH="$FLAKE/bin:${nixBin}/bin:$PATH"
  '';
}
