# Lazy load mise to speed up startup
if command -v mise &> /dev/null; then
  eval "$(mise activate zsh)"
  export MISE_RUBY_BUILD_OPTS=$RUBY_CONFIGURE_OPTS
fi
