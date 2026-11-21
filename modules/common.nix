{ config, pkgs, ... }:
{
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ "pycrs" ];
      MaxAuthTries = 3;
    };
  };

  users.users.pycrs = {
    isNormalUser = true;
    home = "/home/pycrs";
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    packages = with pkgs; [
      nixfmt
      nixd
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJUwbzM9u3nedHK8xZkR5KKQZnMPfdddsT/Miqb4O+UP pycrs@Pycrs-PC"
    ];
  };
}
