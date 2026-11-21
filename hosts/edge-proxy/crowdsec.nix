{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.crowdsec = {
    enable = true;

    hub.collections = [
      "crowdsecurity/sshd"
    ];
    hub.parsers = [
      "crowdsecurity/syslog-logs"
    ];

    settings = {
      config = {
        prometheus = {
          enabled = true;
          level = "full";
          listen_addr = "192.168.100.1";
          listen_port = 6060;
        };

        api = {
          server = {
            online_client.credentials_path = "/var/lib/crowdsec/data/online_api_credentials.yaml";
          };
        };
      };

      console = {
        enrollKeyFile = "/var/lib/crowdsec/data/console_token.txt";
      };

      acquisitions = [
        {
          source = "journalctl";
          journalctl_filter = [
            "_SYSTEMD_UNIT=sshd.service"
          ];
          labels.type = "syslog";
        }
      ];
    };
  };

  networking.firewall.interfaces."wg0".allowedTCPPorts = [ 6060 ];
}
