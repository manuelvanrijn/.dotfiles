# dotfiles bin
export PATH="$PATH:$DOTFILES/bin"
# brew
export PATH="$PATH:/usr/local/bin"
# some random apps loaded from ~/.bin and ~/.local/bin
export PATH="$PATH:$HOME/.bin:$HOME/.local/bin"

# coreutils
export PATH="$PATH:/usr/local/opt/coreutils/libexec/gnubin"
export MANPATH="$MANPATH:/usr/local/opt/coreutils/libexec/gnuman"
export PKG_CONFIG_PATH="$(brew --prefix)/opt/libpq/lib/pkgconfig"

# kubectl krew
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# libpq for postgres
export PATH="$(brew --prefix)/opt/libpq/bin:$PATH"

# Set HuggingFace home directory (used by ck for instance)
export HF_HOME=$HOME/.cache/huggingface
