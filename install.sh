#!/usr/bin/env bash
# 新しいマシンで dotfiles を配置するためのブートストラップ。
# 何度実行しても同じ結果になる（既に正しいリンクなら何もしない）。
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
XDG_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}"

# "リポジトリ内のパス:リンク先" の対応表。追加する設定はここに1行足すだけ。
LINKS=(
  "mise:$XDG_CONFIG/mise"
)

link() {
  local src="$REPO_ROOT/$1" dest="$2"

  if [ ! -e "$src" ]; then
    echo "skip: $src が存在しない" >&2
    return
  fi

  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    echo "ok:   $dest"
    return
  fi

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    local backup="$dest.backup.$(date +%Y%m%d%H%M%S)"
    mv "$dest" "$backup"
    echo "移動: $dest -> $backup"
  fi

  mkdir -p "$(dirname "$dest")"
  ln -s "$src" "$dest"
  echo "作成: $dest -> $src"
}

for entry in "${LINKS[@]}"; do
  link "${entry%%:*}" "${entry#*:}"
done

if command -v mise >/dev/null 2>&1; then
  echo
  echo "mise.lock のバージョンでツールを導入します..."
  mise install
else
  cat <<'EOS'

mise が未インストールです。先に入れてから再実行してください:
  brew install mise
そして ~/.zshrc に以下を追加:
  eval "$(mise activate zsh)"
EOS
fi
