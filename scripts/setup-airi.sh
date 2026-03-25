#!/usr/bin/env bash
set -euo pipefail

# AIRI の初回セットアップ（clone/pull + pnpm i）
# 実行例:
#   AIRI_DIR="$HOME/src/airi" ./setup-airi.sh

AIRI_REPO_URL="${AIRI_REPO_URL:-https://github.com/moeru-ai/airi.git}"
AIRI_DIR="${AIRI_DIR:-$HOME/src/airi}"

echo "setup-airi.sh: AIRI_DIR=${AIRI_DIR}"

mkdir -p "$(dirname "${AIRI_DIR}")"

if [ ! -d "${AIRI_DIR}/.git" ]; then
  git clone "${AIRI_REPO_URL}" "${AIRI_DIR}"
else
  git -C "${AIRI_DIR}" pull --ff-only
fi

cd "${AIRI_DIR}"

# AIRI 側の devShell（FHS）に入りつつ pnpm i を実行
nix develop .#fhs --command pnpm i

echo "setup-airi.sh: done"

