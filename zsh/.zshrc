# VS Code の code コマンド
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# mise 未導入のマシン（初回セットアップ中など）でもシェルが壊れないようにする。
# fzf / starship は mise 管理なので、mise が動いてから初めて存在する。
command -v mise >/dev/null && eval "$(mise activate zsh)"
command -v fzf  >/dev/null && eval "$(fzf --zsh)"

fzf-ghq() {
  local dir
  dir=$(ghq list --full-path | fzf --preview 'ls -la {}') || return
  cd "$dir"
  zle && zle reset-prompt
}
zle -N fzf-ghq
bindkey '^]' fzf-ghq

command -v starship >/dev/null && eval "$(starship init zsh)"

# プラグインは dotfiles の install.sh が ~/.zsh 配下へ clone する。
# 未導入のマシンでもシェルが壊れないよう存在チェックしてから読み込む。
[ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ] \
  && source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# zsh-syntax-highlighting は必ず最後に読み込む
[ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] \
  && source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
