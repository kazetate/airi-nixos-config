{ config, pkgs, ... }:
{
  users.users.airi = {
    isSystemUser = true;
    group = "airi";
    home = "/var/lib/airi";
    createHome = true;
    description = "AIRI service user";
  };

  users.groups.airi = {};

  # AIRI が書き込む領域を明示して、権限と活動範囲を固定する。
  systemd.tmpfiles.rules = [
    "d /var/lib/airi 0750 airi airi -"
    "d /var/lib/airi/src 0750 airi airi -"
    "d /var/log/airi 0750 airi airi -"
  ];

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
      User = "airi";
      Group = "airi";
      WorkingDirectory = "/var/lib/airi";
      # run-airi.sh uses `#!/usr/bin/env bash`, but systemd units may run
      # with a minimal PATH. Call bash explicitly to avoid "env: bash: No such file".
      # Note: NixOS's `serviceConfig.ExecStart` is a list of `ExecStart=...` directives.
      # Passing multiple list items would generate multiple `ExecStart=` lines,
      # which systemd rejects for Type=simple. Keep it as a single command line.
      ExecStart = [ "${pkgs.bash}/bin/bash /etc/airi/run-airi.sh" ];
      # run-airi.sh は `set -u` で `$HOME` を参照するため、systemd 起動時に HOME が未設定だと落ちる。
      Environment = [
        "HOME=/var/lib/airi"
        "AIRI_DIR=/var/lib/airi/src/airi"
        # systemd の PATH は環境によってはかなり薄くなるため、
        # NixOS の system profile を明示して `git` 等が見えるようにする。
        # 一部の環境だと systemd の PATH が極端に薄くなり得るので、
        # NixOS system profile + 典型的なパスをまとめて指定します。
        "PATH=/run/current-system/sw/bin:/run/wrappers/bin:/usr/bin:/bin"
      ];
      UMask = "0027";
      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      ReadWritePaths = [ "/var/lib/airi" "/var/log/airi" ];
      StateDirectory = "airi";
      LogsDirectory = "airi";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };
}

