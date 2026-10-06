host := `hostname`

default:
    @just --list

# Build and activate config for this host
switch:
    sudo nixos-rebuild switch --flake .#{{host}}

# Activate on next boot only
boot:
    sudo nixos-rebuild boot --flake .#{{host}}

# Activate temporarily (reverts on reboot)
test:
    sudo nixos-rebuild test --flake .#{{host}}

# Build a host without activating
build h=host:
    nix build .#nixosConfigurations.{{h}}.config.system.build.toplevel

# Show package changes vs the running system
diff h=host: (build h)
    nix store diff-closures /run/current-system ./result

# Deploy to a remote host over SSH (e.g. via tailscale)
deploy h:
    nixos-rebuild switch --flake .#{{h}} --target-host {{h}} --sudo --ask-sudo-password

# Update all inputs, or one: just update nixpkgs
update *inputs:
    nix flake update {{inputs}}

# Format all files
fmt:
    nix fmt

# Format check + build every host
check:
    nix flake check

# Delete old generations and collect garbage
gc days="14":
    sudo nix-collect-garbage --delete-older-than {{days}}d
    nix store optimise

# List system generations
generations:
    nixos-rebuild list-generations

# Roll back to the previous generation
rollback:
    sudo nixos-rebuild switch --rollback
