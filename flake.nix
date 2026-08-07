{
  description = "My journey with Nix";

  inputs = {
    # Core dependencies.
    nixpkgs.url = "nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable"; # for packages on the edge
    
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Flake parts for modern structure
    flake-parts.url = "github:hercules-ci/flake-parts";

    # Formatter
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    # Secrets manager
    agenix.url = "github:ryantm/agenix";
    secrets = {
      url = "git+ssh://git@github.com/nhamlh/nix-secrets.git";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, flake-parts, treefmt-nix, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      
      imports = [
        treefmt-nix.flakeModule
      ];
      
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        # Treefmt configuration
        treefmt = {
          projectRootFile = "flake.nix";
          programs.nixfmt.enable = true; # Use nixfmt-classic or nixfmt-rfc-style
        };

        # Devshell configuration
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            nixfmt-classic
            git
            # home-manager is often useful in devshell too
            inputs'.home-manager.packages.home-manager
          ];

          shellHook = ''
            export FLAKE="$(pwd)"
          '';
        };
      };

      flake = {
        nixosConfigurations = let
          # Helper to read hosts directory
          readHosts = folder:
            nixpkgs.lib.mapAttrsToList (n: v: n)
              (nixpkgs.lib.filterAttrs (n: v: v == "directory") (builtins.readDir folder));

          hosts = readHosts ./hosts;
          
          # Function to generate a NixOS system
          mkHost = hostName:
            let
              system = "x86_64-linux"; # Hardcoded as per original, could be dynamic later
              pkgs-unstable = import nixpkgs-unstable {
                inherit system;
                config = { allowUnfree = true; };
              };
            in
            nixpkgs.lib.nixosSystem {
              inherit system;
              specialArgs = inputs // { inherit pkgs-unstable; };
              modules = [
                inputs.home-manager.nixosModules.home-manager
                ./modules
                (./. + "/hosts/${hostName}")
                {
                   nixpkgs.config.allowUnfree = true;
                }
              ];
            };
        in
          nixpkgs.lib.genAttrs hosts mkHost;
      };
    };
}
