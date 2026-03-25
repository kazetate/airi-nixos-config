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
      # run-airi.sh uses `#!/usr/bin/env bash`, but systemd units may run
      # with a minimal PATH. Call bash explicitly to avoid "env: bash: No such file".
      # Note: NixOS's `serviceConfig.ExecStart` is a list of `ExecStart=...` directives.
      # Passing multiple list items would generate multiple `ExecStart=` lines,
      # which systemd rejects for Type=simple. Keep it as a single command line.
      ExecStart = [ "${pkgs.bash}/bin/bash /etc/airi/run-airi.sh" ];
      # run-airi.sh は `set -u` で `$HOME` を参照するため、systemd 起動時に HOME が未設定だと落ちる。
      Environment = [
        "HOME=/root"
        # systemd の PATH は環境によってはかなり薄くなるため、
        # NixOS の system profile を明示して `git` 等が見えるようにする。
        # 一部の環境だと systemd の PATH が極端に薄くなり得るので、
        # NixOS system profile + 典型的なパスをまとめて指定します。
        "PATH=/run/current-system/sw/bin:/run/wrappers/bin:/usr/bin:/bin"
      ];
      Restart = "on-failure";
    };
  };
}

