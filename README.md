# airi-nixos-config

## Usage

run this command on your nix.

```bash
mkdir ~/src
cd ~/src
sudo nixos-rebuild switch --flake github:kazetate/airi-nixos-config#airi-vm --no-write-lock-file
# AIRI autostart is disabled by default for safety.
# Enable it only after confirming boot/login stability:
#   sudo sed -i 's/services.airiAutostart.enable = false;/services.airiAutostart.enable = true;/' /etc/nixos/hosts/airi-vm/configuration.nix
#   sudo nixos-rebuild switch --flake .#airi-vm --no-write-lock-file
```
