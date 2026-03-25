{
  description = "AIRI NixOS configuration (scaffold)";

  inputs = {
    # Choose a pinned nixpkgs revision when you are ready to make this repo fully reproducible.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        airi-vm = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/airi-vm/configuration.nix
            ./modules/desktop-plasma.nix
            ./modules/vmware.nix
            ./modules/devtools.nix
            ./modules/airi-autostart.nix
          ];
        };
      };
    };
}

