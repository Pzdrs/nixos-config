{
  config,
  lib,
  pkgs,
  ...
}:
{
  virtualisation.docker = {
    enable = true;

    daemon.settings = {
      metrics-addr = "0.0.0.0:9323";
      log-driver = "json-file";
      log-opts = {
        max-size = "10m";
        max-file = "3";
      };
      userns-remap = "default";
    };
  };

  users.groups.dockremap.gid = 10000;

  users.users = {
    dockremap = {
      isSystemUser = true;
      uid = 10000;
      group = "dockremap";
      subUidRanges = [
        {
          startUid = 100000;
          count = 65536;
        }
      ];
      subGidRanges = [
        {
          startGid = 100000;
          count = 65536;
        }
      ];
    };
  };

  virtualisation.oci-containers = {
    backend = "docker"; 
    containers.autoheal = {
      image = "docker.io/willfarrell/autoheal:latest";
      autoStart = true;

      environment = {
        AUTOHEAL_CONTAINER_LABEL = "autoheal"; # or "autoheal" to only watch labeled containers
        AUTOHEAL_INTERVAL = "5";
        AUTOHEAL_START_PERIOD = "0";
        AUTOHEAL_DEFAULT_STOP_TIMEOUT = "10";
        AUTOHEAL_ONLY_MONITOR_RUNNING = "false";
        CURL_TIMEOUT = "30";
      };

      volumes = [
        "/var/run/docker.sock:/var/run/docker.sock:ro"
      ];

      extraOptions = [
        "--network=none"
      ];
    };
  };
}
