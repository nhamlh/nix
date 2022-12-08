WORK IN PROGRESS

# Installation

1. Boot into the installer

2. Switch to root user

3. Partition the disk and mount root to /mnt

4. Clone this repo
``` sh
NIX_REPO_PATH=/tmp/nix
git clone git@github.com:nhamlh/nix $NIX_REPO_PATH
cd $NIX_REPO_PATH
```

5. Append this host (if new) to this repo

``` sh
HOST=<my new machine>

mkdir machines/$HOST
nixos-generate-config --root /mnt --dir ${NIX_REPO_PATH}/machines/$HOST
mv machines/$HOST/hardware-configurationn.nix machines/$HOST/hardware.nix
rm -f machines/$HOST/configuration.nix
```

6. Install nixos
nixos-install --root /mnt --impure --flake .#$HOST
