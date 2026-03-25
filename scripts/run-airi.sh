#!/usr/bin/env bash
set -euo pipefail

# AIRI の起動（repo がなければ clone、あれば pull して pnpm i → dev を実行）
#
# chat.md の自動化案(A/B)に合わせた最小構成です。
#
# 環境変数 / 先頭引数:
# - AIRI_DIR: clone先 (default: $HOME/src/airi)
# - AIRI_REPO_URL: リポジトリURL (default: https://github.com/moeru-ai/airi.git)
# - AIRI_MODE: 起動モード (default: dev)
#              dev と tamagotchi
# - 先頭引数が tamagotchi の場合も tamagotchi 扱いにします

AIRI_REPO_URL="${AIRI_REPO_URL:-https://github.com/moeru-ai/airi.git}"
AIRI_DIR="${AIRI_DIR:-$HOME/src/airi}"

MODE="${AIRI_MODE:-dev}"
if [ "${1:-}" = "tamagotchi" ]; then
  MODE="tamagotchi"
fi

echo "run-airi.sh: AIRI_DIR=${AIRI_DIR}"
echo "run-airi.sh: MODE=${MODE}"

mkdir -p "$(dirname "${AIRI_DIR}")"

if [ ! -d "${AIRI_DIR}/.git" ]; then
  git clone "${AIRI_REPO_URL}" "${AIRI_DIR}"
else
  git -C "${AIRI_DIR}" pull --ff-only
fi

cd "${AIRI_DIR}"

# 依存導入
nix develop .#fhs --command pnpm i

# 起動（dev:tamagotchi は通常は常駐プロセスのため exec で置き換える）
case "${MODE}" in
  dev)
    exec nix develop .#fhs --command pnpm dev
    ;;
  tamagotchi)
    # chat.md 方針に合わせる:
    # tamagotchi の場合は --enable-unsafe-webgpu だけ付与
    exec nix develop .#fhs --command pnpm dev:tamagotchi -- --enable-unsafe-webgpu
    ;;
  *)
    echo "run-airi.sh: ERROR invalid MODE=${MODE} (expected dev or tamagotchi)" >&2
    exit 2
    ;;
esac

