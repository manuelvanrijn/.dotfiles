alias reload!='. ~/.zshrc'

# rake helpers
alias pr-rspec='RAILS_ENV=test rake db:drop && echo "test db dropped" && \
  RAILS_ENV=test rake db:create && echo "test db created" && \
  RAILS_ENV=test rake db:migrate >> /dev/null && echo "test db migrated" && \
  git checkout db/schema.rb >> /dev/null && \
  rspec spec'

# Always enable colored `grep` output
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Clean up LaunchServices to remove duplicates in the “Open With” menu
alias lscleanup="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

# show all $PATH
alias path='echo -e ${PATH//:/\\n}'

# brew upgrade
alias bup='brew update && brew upgrade && rm -rf $(brew --cache) && brew cleanup'

# edit host file
alias edithost='sudo e /etc/hosts'

alias gup='project=${PWD##*/}; gh repo create manuelvanrijn/${project}; git remote add uppersource git@github.com:manuelvanrijn/${project}.git'
alias pullpushall='update_git_repos'

alias toron='sudo networksetup -setsocksfirewallproxy Wi-Fi 127.0.0.1 9050 off; sudo networksetup -setsocksfirewallproxystate Wi-Fi on'
alias toroff='sudo networksetup -setsocksfirewallproxy Wi-Fi ""; sudo networksetup -setsocksfirewallproxystate Wi-Fi off'

# exa in favour of ls
alias ls="exa -lhgbH --git"
alias la="exa -lahgbH --git"

# bat in favour of cat
alias cat="bat"

# use trash instead of the default rm command
if [ -f /usr/local/bin/trash ]; then alias rm="/usr/local/bin/trash"; fi
