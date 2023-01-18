# brew
eval "$(/opt/homebrew/bin/brew shellenv)"

source `brew --prefix`/etc/profile.d/z.sh
source `brew --prefix`/share/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# direnv
eval "$(direnv hook zsh)"

## kubectl, minikube & stern
# source <(kubectl completion zsh)
# source <(minikube completion zsh)
# source <(stern --completion=zsh)
