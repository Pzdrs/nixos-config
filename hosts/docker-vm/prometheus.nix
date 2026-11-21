{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.prometheus = {
    enable = true;
    port = 9090;
    extraFlags = [
      "--web.enable-lifecycle"
    ];
    scrapeConfigs = [
      {
        job_name = "prometheus";
        static_configs = [
          { targets = [ "127.0.0.1:9090" ]; }
        ];
      }
      {
        job_name = "docker";
        static_configs = [
          { targets = [ "127.0.0.1:9323" ]; }
        ];
      }
      {
        job_name = "lixos";
        static_configs = [
          { targets = [ "192.168.100.1:6060" ]; }
        ];
      }
    ];
  };
}
