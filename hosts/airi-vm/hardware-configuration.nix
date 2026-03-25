{ config, pkgs, ... }:
{
  # Placeholder for the generated hardware-configuration.nix.
  # You should replace the filesystem device with the real one for your VM.
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  swapDevices = [ ];
}

