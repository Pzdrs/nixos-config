deploy target build host_name:
    nix shell nixpkgs#nixos-rebuild -c nixos-rebuild switch --flake .#{{host_name}} --target-host {{target}} --build-host {{build}} --elevate=sudo