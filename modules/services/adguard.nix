# How to setup private DNS:
#
# Point Tailscale custome DNS server to adguard server, override local dns
# server. With this option, all nodes in tailnet will automatically use this dns
# server.
#
# [optional] Setup firefox to accept private zone, in this example *.home:
# browser.fixup.domainsuffixwhitelist.home
#
#
{ options, config, lib, pkgs, ... }:

with builtins;
with lib;
let
  cfg = config.my.modules.services.adguard;
  workDir = "/var/lib/adguard";
in {
  options.my.modules.services.adguard = { enable = mkEnableOption "adguard"; };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ adguardhome ];

    system.activationScripts.adguardWorkDir = ''
      mkdir -m 1755 -p ${workDir}
    '';

    systemd.services = {
      adguard = {
        enable = true;
        description = "Adguard Home";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        restartIfChanged = true;

        serviceConfig = {
          DynamicUser = false;
          User = "root";
          Restart = "always";
          WorkingDirectory = workDir;
          ExecStart = "${pkgs.adguardhome}/bin/adguardhome -w ${workDir}";
        };
      };
    };
  };
}
