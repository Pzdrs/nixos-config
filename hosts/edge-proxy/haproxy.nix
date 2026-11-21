{ config, pkgs, ... }: {
  services.haproxy = {
    enable = true;

    config = ''
      global
          log stdout format raw local0

      defaults
          log global
          mode tcp
          timeout connect 5s
          timeout client 60s
          timeout server 60s

      frontend http_in
          bind *:80
          default_backend http_backend

      backend http_backend
          server backend 192.168.100.0:80 send-proxy-v2

      frontend https_in
          bind *:443
          default_backend https_backend

      backend https_backend
          server backend 192.168.100.0:443 send-proxy-v2
    '';
  };
}
