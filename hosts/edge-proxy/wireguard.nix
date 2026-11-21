{ config, pkgs, ... }: {
  networking.wireguard = {
    enable = true;
    interfaces = {
      wg0 = {
        ips = [ "192.168.100.1/31" ];
        listenPort = 51820;
        privateKeyFile = "/etc/wireguard/private.key";

        peers = [
          {
            publicKey = "/XhKUmg3HI1LnuAmmtOOxXYRjXbhjODOPQxPRR56CXg=";
            presharedKeyFile = "/etc/wireguard/psk.key";
            allowedIPs = [
              "192.168.100.0/31"
              "10.0.0.0/24"
            ];
          }
        ];
      };
    };
  };

  networking.firewall.allowedUDPPorts = [ 51820 ];
}
