alias reload!='. ~/.zshrc'

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

# eza in favour of ls
alias ls="eza -lhgbH --git"
alias la="eza -lahgbH --git"

# bat in favour of cat
alias cat="bat"

# use trash instead of the default rm command
if [ -f /usr/local/bin/trash ]; then alias rm="/usr/local/bin/trash"; fi

# search rails routes using fzf
alias routes="bin/rails routes | fzf -e"

alias ring="open raycast://confetti"
