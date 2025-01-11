{
  description = "My journey with Nix";

  inputs = {
    # Core dependencies.
    nixpkgs.url = "nixpkgs/nixos-24.11";
    nixpkgs-unstable.url =
      "nixpkgs/nixpkgs-unstable"; # for packages on the edge
    home-manager.url = "github:rycee/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Secrets manager
    agenix.url = "github:ryantm/agenix";
    secrets = {
      url = "git+ssh://git@github.com/nhamlh/nix-secrets.git";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, ... }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };

      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config = { allowUnfree = true; };
      };

      hosts = pkgs.lib.mapAttrsToList (n: v: n)
        (pkgs.lib.filterAttrs (n: v: v == "directory")
          (builtins.readDir ./hosts));
    in {
      nixosConfigurations = pkgs.lib.genAttrs hosts (h:
        nixpkgs.lib.nixosSystem {
          inherit system pkgs;

          specialArgs = inputs // { pkgs-unstable = pkgs-unstable; };
          modules = [ ./modules (./. + "/hosts/${h}") ];
        });

      devShells = import ./shell.nix { inherit system pkgs; };
    };
}
