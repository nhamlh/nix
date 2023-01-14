# Installation

1. Boot into the installer and switch to root user
2. Partition the disk and mount root to /mnt
3. Clone this repo
``` sh
nix-shell -p git nixFlakes

NIX_REPO_PATH=/tmp/nix
git clone https://github.com/nhamlh/nix $NIX_REPO_PATH && cd $NIX_REPO_PATH

```

4. Generate config for this host and append to this repo

``` sh
HOST=<my new machine>

mkdir hosts/$HOST
nixos-generate-config --root /mnt --dir ${NIX_REPO_PATH}/hosts/$HOST
mv hosts/$HOST/configuration.nix hosts/$HOST/default.nix
```

5. Install nixos
``` sh
NIXPKGS_ALLOW_UNFREE=1 nixos-install --root /mnt --impure --flake ${NIX_REPO_PATH}#$HOST
```
