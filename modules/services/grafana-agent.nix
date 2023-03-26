{ options, config, lib, pkgs, ... }:

with builtins;
with lib;
let
  cfg = config.my.modules.services.grafana-agent;
  configFile = "grafana-agent/config.yaml";
  secrets = import config.age.secrets.secrets.path;
in {
  options.my.modules.services.grafana-agent = {
    enable = mkEnableOption "Grafana Agent";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ grafana-agent ];

    environment.etc = {
      "${configFile}" = {
        text = ''
          server:
            log_level: warn

          metrics:
            global:
              scrape_interval: 15s
              remote_write:
              - url: https://prometheus-prod-18-prod-ap-southeast-0.grafana.net/api/prom/push
                basic_auth:
                  username: 635007
                  password: ''${PROM_KEY}

          logs:
            configs:
            - name: default
              positions:
                filename: /tmp/positions.yaml
              scrape_configs:
                - job_name: varlogs
                  static_configs:
                    - targets: [localhost]
                      labels:
                        job: varlogs
                        __path__: /var/log/*log
              clients:
                - url: https://logs-prod-011.grafana.net/loki/api/v1/push
                  basic_auth:
                    username: 316474
                    password: ''${LOKI_KEY}


          integrations:
            node_exporter:
              enabled: true
        '';

        mode = "0640";
      };
    };

    systemd.services = {
      grafana-agent = {
        enable = true;
        description = "Grafana Agent";
        after = [ "network.target" ];
        restartIfChanged = true;

        environment = {
          PROM_KEY = "${secrets.keys.prometheus}";
          LOKI_KEY = "${secrets.keys.loki}";
        };

        serviceConfig = {
          DynamicUser = false;
          User = "root";
          ExecStart =
            "${pkgs.grafana-agent}/bin/agent -config.expand-env -config.file=/etc/${configFile}";
          Restart = "always";
        };
      };
    };
  };
}
