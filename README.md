# Installation

- Boot into the installer and switch to root user
- Partition the disk and mount root to /mnt
- Install bitwarden-cli and retrieve ssh key and add to ssh-agent. It's needed to pull secrets from private repo
``` sh
nix-shell -p git bitwarden-cli ssh-agent jq

eval $(ssh-agent &)
mkdir ~/.ssh

bw login <email>

# Get item and attachment id
bw list items --search <item name> | jq

# Download key
bw get attachment <attachment id> --itemid <item id> --output ~/.ssh/id_ed25519

# Add key to ssh-agent
ssh-add ~/.ssh/id_ed25519
```

- Clone this repo
``` sh
nix-shell -p git nixFlakes

NIX_REPO_PATH=/tmp/nix
git clone --depth=1 https://github.com/nhamlh/nix $NIX_REPO_PATH && cd $NIX_REPO_PATH
```

- Generate config for this host and append to this repo
``` sh
HOST=<my new machine>

mkdir hosts/$HOST
nixos-generate-config --root /mnt --dir ${NIX_REPO_PATH}/hosts/$HOST
mv hosts/$HOST/configuration.nix hosts/$HOST/default.nix
```

- Install nixos
``` sh
NIXPKGS_ALLOW_UNFREE=1 nixos-install --root /mnt --impure --flake ${NIX_REPO_PATH}#$HOST
```

# Host naming
servers fleet are named of greek numbers. For example from one to ten: ena, thio, tria, tessera, pendi, exi, efta, ochto, ennea, theka.
