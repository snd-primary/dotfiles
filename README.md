# dotfiles

macOS (Apple Silicon) 向けの個人設定。`~/.config` 配下へシンボリックリンクで配置する。

## 構成

| パス | リンク先 | 内容 |
| --- | --- | --- |
| `mise/` | `~/.config/mise` | mise のグローバル設定 (`config.toml`) とバージョンロック (`mise.lock`) |
| `ghostty/` | `~/.config/ghostty` | Ghostty ターミナルの設定 |
| `zsh/.zshrc` | `~/.zshrc` | 対話シェルの設定（mise / fzf / starship / ghq 連携、キーバインド） |
| `zsh/.zprofile` | `~/.zprofile` | ログインシェルの設定（Homebrew の `shellenv`） |
| `hammerspoon/` | `~/.hammerspoon` | Hammerspoon の設定（ウィンドウ配置のホットキー） |

nvim の設定は別リポジトリ [`dotfiles-nvim`](https://github.com/snd-primary/dotfiles-nvim) にあり、`~/.config/nvim` へ直接リンクしている。

zsh プラグイン（zsh-autosuggestions / zsh-syntax-highlighting）はサードパーティのリポジトリなので、
このリポジトリには含めず `install.sh` が `~/.zsh/` 配下へ clone する。

## 新しいマシンでのセットアップ

```sh
# 1. Homebrew と mise を入れる
brew install mise git

# 2. このリポジトリを取得（ghq 運用に合わせる場合）
ghq get snd-primary/dotfiles
cd "$(ghq root)/github.com/snd-primary/dotfiles"

# 3. リンク作成 + プラグイン clone + ツール導入
./install.sh

# 4. 新しいシェルを開く
exec zsh
```

`.zshrc` 側で `mise activate` を行うため、shell 統合の手動追記は不要。

`install.sh` は冪等で、以下を行う。

1. `LINKS` のシンボリックリンクを作成する。リンク先に既存ファイルがあれば `*.backup.<timestamp>` へ退避してから張り替える
2. zsh プラグインが未取得なら `~/.zsh/` へ clone する
3. `mise install` を実行し、`mise.lock` に記録されたバージョンをそのまま再現する

`.zshrc` / `.zprofile` は各コマンドの存在を確認してから読み込むので、
ツール導入前にシェルを開いてもエラーにならない。

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

zsh プラグインを増やす場合は `ZSH_PLUGINS` に clone 元 URL を1行追加する。
