{
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./../../modules/common.nix
    ./vault-agent.nix
    ./docker.nix
    ./prometheus.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  services.qemuGuest.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # networking.hostName = "nixos"; # Define your hostname.

  networking.networkmanager.enable = true;
  networking.nameservers = [ "10.0.0.9" ];

  networking = {
    vlans = {
      _100_mgmt = {
        id = 100;
        interface = "ens19";
      };
      _99_infra = {
        id = 999;
        interface = "ens19";
      };
    };

    interfaces._100_mgmt.ipv4.addresses = [
      {
        address = "10.100.0.2";
        prefixLength = 24;
      }
    ];
    interfaces._99_infra.ipv4.addresses = [
      {
        address = "10.99.0.5";
        prefixLength = 24;
      }
    ];
  };

  networking.nftables.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
    ];
  };

  programs.nix-ld.enable = true;
  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
  ];

  system.stateVersion = "26.05";
}
