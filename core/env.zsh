# brew
eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH="$PATH:$(brew --prefix)/bin"

export EDITOR='code'

# correct encoding
export LC_CTYPE=en_US.UTF-8
export LANG=en_US.UTF-8

export CPPFLAGS="$CPPFLAGS -I$(brew --prefix jemalloc)/include"
export LDFLAGS="$LDFLAGS -L$(brew --prefix jemalloc)/lib"
export RUBY_CONFIGURE_OPTS="--with-jemalloc --disable-install-doc --enable-yjit --with-libyaml-dir=$(brew --prefix libyaml)"
# export RUBY_CONFIGURE_OPTS="--with-jemalloc --with-readline-dir=($(brew --prefix readline) --with-libyaml-dir=$(brew --prefix libyaml) --with-openssl-dir=$(brew --prefix openssl@3) --disable-install-doc --enable-yjit"
export MALLOC_CONF="dirty_decay_ms:1000,narenas:2,stats_print:false"
export RUBY_YJIT_ENABLE=1

export DOCKER_CLI_HINTS=false
