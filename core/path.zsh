# dotfiles bin
export PATH="$PATH:$DOTFILES/bin"
# brew
export PATH="$PATH:/usr/local/bin"
# some random apps loaded from ~/.bin and ~/.local/bin
export PATH="$PATH:$HOME/.bin:$HOME/.local/bin"
# android platform tools
export PATH="$PATH:$HOME/Library/Android/sdk/platform-tools"

# coreutils
export PATH="$PATH:/usr/local/opt/coreutils/libexec/gnubin"
export MANPATH="$MANPATH:/usr/local/opt/coreutils/libexec/gnuman"

# kubectl krew
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
