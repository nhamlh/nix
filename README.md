# Installation

- Boot the NixOS minimal installer and get network access (disks are handled by disko below)
- Install bitwarden-cli and retrieve ssh key and add to ssh-agent. It's needed to pull secrets from private repo
``` sh
nix-shell -p git bitwarden-cli jq

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

- Pick a host name and disk layout, then partition, format and mount with [disko](https://github.com/nix-community/disko). This wipes the disk.
``` sh
HOST=<my new machine>

mkdir hosts/$HOST
cp templates/disko-ext4.nix hosts/$HOST/disk.nix
lsblk                          # find the target disk
$EDITOR hosts/$HOST/disk.nix   # set `device` (and swap size)

sudo nix --extra-experimental-features 'nix-command flakes' \
  run github:nix-community/disko/latest -- --mode destroy,format,mount hosts/$HOST/disk.nix
```

- Generate hardware config without filesystems (disko owns those)
``` sh
nixos-generate-config --no-filesystems --root /mnt --dir ${NIX_REPO_PATH}/hosts/$HOST
mv hosts/$HOST/hardware-configuration.nix hosts/$HOST/hardware.nix
mv hosts/$HOST/configuration.nix hosts/$HOST/default.nix
```

- Edit `hosts/$HOST/default.nix`: set `imports = [ ./hardware.nix ./disk.nix ];`, `networking.hostName`, and the `my.modules` you want (see other hosts). `git add hosts/$HOST`, since flakes only see tracked files.

- Install nixos
``` sh
nixos-install --root /mnt --flake ${NIX_REPO_PATH}#$HOST
```

- Rekey nix-secrets with pubkey of this new host

- Commit and push `hosts/$HOST`. Later updates: `just deploy $HOST` from another machine, or `just switch` on the host.

Existing hosts (ena, thio, tria, amd-desktop) predate disko and use UUID mounts in `hardware.nix`; move them to disko only on reinstall.

# Host naming
servers fleet are named of greek numbers. For example from one to ten: ena, thio, tria, tessera, pendi, exi, efta, ochto, ennea, theka.

# References
- https://serokell.io/blog/practical-nix-flakes
- https://shen.hong.io/nixos-home-manager-wayland-sway/
- https://nixos.wiki/wiki/Storage_optimization
- https://nix.dev/manual/nix/2.24/package-management/garbage-collector-roots.html
- https://nixos.org/guides/nix-pills/11-garbage-collector
- https://nixos-and-flakes.thiscute.world
