{ system ? builtins.currentSystem, pkgs ? import <nixpkgs> { inherit system; }
}:

with pkgs;
let
  nixBin = writeShellScriptBin "nix" ''
    ${nixFlakes}/bin/nix --option experimental-features "nix-command flakes" "$@"
  '';
in mkShell {
  inherit system;
  buildInputs = [ nixfmt ];
  shellHook = ''
    export FLAKE="$(pwd)"
    export PATH="$FLAKE/bin:${nixBin}/bin:$PATH"
  '';
}
