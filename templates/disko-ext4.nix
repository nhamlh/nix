# Disko layout template for new hosts: GPT, 1G ESP at /boot, swap, ext4 root.
# Copy to hosts/<host>/disk.nix, set `device`, import it from default.nix.
# Matches the layout of existing hosts (systemd-boot + ext4).
{
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/nvme0n1"; # CHANGE ME: check with `lsblk`
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          size = "1G";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };
        swap = {
          size = "16G";
          content.type = "swap";
        };
        root = {
          size = "100%";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        };
      };
    };
  };
}
