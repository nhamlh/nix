{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.my.modules.base.tailscale;
  tsInterface = "tailscale0";
  #tskey = config.age.secrets.tskey.path;

in {
  options.my.modules.base.tailscale = {
    enable = mkEnableOption "Tailscale network";
  };

  config = {
    networking.firewall = {
      # enable the firewall
      enable = true;

      checkReversePath = "loose";

      trustedInterfaces = [ tsInterface ];

      # allow the Tailscale UDP port through the firewall
      allowedUDPPorts = [ config.services.tailscale.port ];

      # allow you to SSH in over the public internet
      allowedTCPPorts = [ 22 ];
    };

    environment.systemPackages = with pkgs; [ tailscale jq ];
    services.tailscale.enable = true;

    # create a oneshot job to authenticate to Tailscale
    systemd.services.tailscale-autoconnect = {
      description = "Automatic connection to Tailscale";

      # make sure tailscale is running before trying to connect to tailscale
      after = [ "network-pre.target" "tailscale.service" ];
      wants = [ "network-pre.target" "tailscale.service" ];
      wantedBy = [ "multi-user.target" ];

      # set this service as a oneshot job
      serviceConfig.Type = "oneshot";

      # have the job run this shell script
      script = with pkgs; ''
        # wait for tailscaled to settle
        sleep 2

        # check if we are already authenticated to tailscale
        status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
        if [ $status = "Running" ]; then # if so, then do nothing
          exit 0
        fi

        # otherwise authenticate with tailscale
        ${tailscale}/bin/tailscale up -authkey "foobar"
      '';
    };
  };
}
