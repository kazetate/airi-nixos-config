{ config, pkgs, ... }:
{
  # AIRI layer: install startup script and run it via systemd (placeholder).
  environment.etc."airi/run-airi.sh".source = ../scripts/run-airi.sh;
  environment.etc."airi/run-airi.sh".mode = "0755";

  systemd.services.airi-autostart = {
    description = "AIRI autostart (placeholder)";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = [ "/etc/airi/run-airi.sh" ];
      Restart = "on-failure";
    };
  };
}

