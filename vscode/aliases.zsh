alias vscode_export_extensions='code --list-extensions > ~/.dotfiles/vscode/extensions'
alias vscode_install_extensions='while read in; do code --install-extension "$in"; done < ~/.dotfiles/vscode/extensions'
