alias reload!='. ~/.zshrc'

# rake helpers
alias pr-rspec='RAILS_ENV=test rake db:drop && echo "test db dropped" && \
  RAILS_ENV=test rake db:create && echo "test db created" && \
  RAILS_ENV=test rake db:migrate >> /dev/null && echo "test db migrated" && \
  git checkout db/schema.rb >> /dev/null && \
  rspec spec'

alias https-server='http-server --ssl --cert ~/.ssl/localhost.crt --key ~/.ssl/localhost.key -a localhost'

# Always enable colored `grep` output
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Flush Directory Service cache
alias flush="dscacheutil -flushcache && killall -HUP mDNSResponder"

# Clean up LaunchServices to remove duplicates in the “Open With” menu
alias lscleanup="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

# show all $PATH
alias path='echo -e ${PATH//:/\\n}'

# brew upgrade
alias bup='brew update && brew upgrade && brew cleanup && brew cask cleanup && rm -rf $(brew --cache)'
