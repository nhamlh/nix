# Installation

- Follow NixOS installation guide to prepare the disk: https://nixos.wiki/wiki/NixOS_Installation_Guide
- Install bitwarden-cli and retrieve ssh key and add to ssh-agent. It's needed to pull secrets from private repo
``` sh
nix-shell -p nixFlakes git bitwarden-cli jq

eval $(ssh-agent &)
mkdir ~/.ssh

# Login to Bitwarden
export BW_SESSION=$(bw login <email> --raw)

# Download deploy key which is to pull nix-secrets
DEPLOY_KEY_ID=$(bw list items --search nix-secrets-deploy-key | jq -r .[0].id)
ATTACHMENT_ID=$(bw list items --search nix-secrets-deploy-key | jq -r .[0].attachments[0].id)
bw get attachment $ATTACHMENT_ID --itemid $DEPLOY_KEY_ID --output $HOME/.ssh/id_ed25519

# Add key to ssh-agent
ssh-add ~/.ssh/id_ed25519
```

- Clone this repo
``` sh
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

- Rekey nix-secrets with pubkey of this new host

# Host naming
servers fleet are named of greek numbers. For example from one to ten: ena, thio, tria, tessera, pendi, exi, efta, ochto, ennea, theka.
