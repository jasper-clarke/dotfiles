HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

fpath+="$HOME/.myzsh/zsh-completions/src"

autoload -Uz compinit
compinit

source $HOME/.myzsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/.myzsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/config.json)"

eval "$(zoxide init zsh)"

alias -- 'cd'='z'
alias -- 'ls'='eza'
alias -- 'rm'='trash-put'
alias dotfiles='git --git-dir=/home/jasper/.dotfiles --work-tree=/'

dot() {
  if [[ "$#" -eq 0 ]]; then
    (cd /
    for i in $(dotfiles ls-files); do
      echo -n "$(dotfiles -c color.status=always status $i -s | sed "s#$i##")"
      echo -e "¬/$i¬\e[0;33m$(dotfiles -c color.ui=always log -1 --format="%s" -- $i)\e[0m"
    done
    ) | column -t --separator=¬ -T2
  else
    dotfiles $*
  fi
}
