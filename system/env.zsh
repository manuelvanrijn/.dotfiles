# brew
eval "$(/opt/homebrew/bin/brew shellenv)"

export EDITOR='code'

# correct encoding
export LC_CTYPE=en_US.UTF-8
export LANG=en_US.UTF-8

export RUBY_CONFIGURE_OPTS=--with-jemalloc
export RUBY_YJIT_ENABLE=1
