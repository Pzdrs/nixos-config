{
  config,
  lib,
  pkgs,
  ...
}:
let
  vault = "https://vault.pycrs.cz";
in
{
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "vault"
      "vault-bin"
    ];

  services.vault-agent.instances.homelab-prod = {
    enable = true;
    package = pkgs.vault-bin;
    settings = {
      vault = {
        address = vault;
      };

      auto_auth = {
        method = {
          type = "approle";
          config = {
            role_id_file_path = "/var/lib/vault/roleid";
            secret_id_file_path = "/var/lib/vault/secretid";
            remove_secret_id_file_after_reading = false;
          };
        };
        sinks = [
          {
            sink = {
              type = "file";
              config = {
                path = "/run/vault-agent/token";
                mode = 384; # 0600
              };
            };
          }
        ];
      };

      template = [
        {
          contents = ''
            {{ with secret "prod/data/docker/book-orbit" }}
            POSTGRES_USER={{ .Data.data.db_username }}
            POSTGRES_PASSWORD={{ .Data.data.db_password }}
            POSTGRES_DB=bookorbit

            JWT_SECRET={{ .Data.data.jwt_secret }}
            {{ end }}
          '';
          destination = "/run/secrets/book-orbit/app.env";
          perms = "0600";
        }
      ];
    };
  };
}
