export NODEJS_CHECK_SIGNATURES="no"

source $HOME/.asdf/asdf.sh
source $HOME/.asdf/completions/asdf.bash

export GLOBAL_NODE_VERSION=$(asdf current nodejs | perl -pe '($_)=/([0-9]+([.][0-9]+)+)/' )
export PATH="$PATH:$HOME/.asdf/installs/nodejs/$GLOBAL_NODE_VERSION/.npm/bin"

# use the master branch as ruby-build version
export ASDF_RUBY_BUILD_VERSION="master"
