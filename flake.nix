{
  description = "My journey with Nix";

  inputs = {
    # Core dependencies.
    nixpkgs.url = "nixpkgs/nixos-unstable"; # primary nixpkgs
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

  outputs = inputs@{ self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { config = { allowUnfree = true; }; };
    in {
      nixosConfigurations = {
        amd-desktop = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = inputs;
          modules = [ ./modules ./hosts/amd-desktop ];
        };

        dell-mini = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = inputs;
          modules = [ ./modules ./hosts/dell-mini ];
        };

        lenovo-m900 = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = inputs;
          modules = [ ./modules ./hosts/lenovo-m900 ];
        };
      };
    };
}
