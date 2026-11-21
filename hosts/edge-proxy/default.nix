{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./../../modules/common.nix
    ./wireguard.nix
    ./haproxy.nix
    ./crowdsec.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings = {
    max-jobs = 1;
    cores = 1;
  };

  boot.loader.grub.enable = true;

  # networking.hostName = "nixos"; # Define your hostname.

  security.sudo.wheelNeedsPassword = false;

  networking.networkmanager.enable = true;

  services.openssh.ports = [ 1022 ];

  networking.usePredictableInterfaceNames = false;
  networking.useDHCP = false;
  # required for ssh?
  networking.interfaces.eth0.useDHCP = true;

  networking.nftables.enable = true;
  networking.nftables.ruleset = builtins.readFile ./nftables/cloudflare.nft;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      80
      443
    ];
  };

  environment.systemPackages = with pkgs; [
    inetutils
    mtr
    sysstat
    vim
  ];

  programs.nix-ld.enable = true;

  time.timeZone = "Europe/Prague";

  system.stateVersion = "26.05";
}
