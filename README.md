# dotfiles

macOS (Apple Silicon) 向けの個人設定。`~/.config` 配下へシンボリックリンクで配置する。

## 構成

| パス | リンク先 | 内容 |
| --- | --- | --- |
| `mise/` | `~/.config/mise` | mise のグローバル設定 (`config.toml`) とバージョンロック (`mise.lock`) |

nvim の設定は別リポジトリ [`dotfiles-nvim`](https://github.com/snd-primary/dotfiles-nvim) にあり、`~/.config/nvim` へ直接リンクしている。

## 新しいマシンでのセットアップ

```sh
# 1. mise 本体を入れる
brew install mise

# 2. ~/.zshrc に shell 統合を追加
echo 'eval "$(mise activate zsh)"' >> ~/.zshrc

# 3. このリポジトリを取得（ghq 運用に合わせる場合）
ghq get snd-primary/dotfiles
cd "$(ghq root)/github.com/snd-primary/dotfiles"

# 4. リンク作成 + ツール導入
./install.sh
```

`install.sh` は冪等で、リンク先に既存ファイルがあれば `*.backup.<timestamp>` に退避してから張り替える。
最後に `mise install` を実行し、`mise.lock` に記録されたバージョンをそのまま再現する。

## mise のバージョン運用

`config.toml` の指定は `latest` / `lts` だが、実際に入るバージョンは `mise.lock` が決める。
これによりマシン間でバージョンがずれない。

```sh
# ロック済みバージョンで導入（新マシン・CI）
mise install

# ツールを新しいバージョンへ上げる（ロックも更新される）
mise upgrade

# 特定ツールだけ上げる
mise upgrade node

# config.toml にツールを追加したあとロックへ反映
mise lock -g
```

`mise upgrade` / `mise lock -g` を実行したら `mise.lock` の差分をコミットして他マシンへ反映する。

## 設定を追加するとき

1. 対象ファイルをこのリポジトリへ移動する
2. `install.sh` の `LINKS` 配列に `"リポジトリ内パス:リンク先"` を1行追加する
3. `./install.sh` を実行してリンクを張り直す
