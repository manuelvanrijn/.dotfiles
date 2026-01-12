# brew
export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
export HOMEBREW_REPOSITORY="/opt/homebrew"
fpath=("/opt/homebrew/share/zsh/site-functions" $fpath)
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
[ -z "${MANPATH-}" ] || export MANPATH=":${MANPATH#:}"
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"

export EDITOR='code'

# correct encoding
export LC_CTYPE=en_US.UTF-8
export LANG=en_US.UTF-8

export CPPFLAGS="$CPPFLAGS -I/opt/homebrew/opt/jemalloc/include"
export LDFLAGS="$LDFLAGS -L/opt/homebrew/opt/jemalloc/lib"
export RUBY_CONFIGURE_OPTS="--with-jemalloc --disable-install-doc --enable-yjit --with-libyaml-dir=/opt/homebrew/opt/libyaml --with-zlib-dir=/opt/homebrew/opt/zlib"
export MALLOC_CONF="dirty_decay_ms:1000,narenas:2,stats_print:false"
export RUBY_YJIT_ENABLE=1

export DOCKER_CLI_HINTS=false
