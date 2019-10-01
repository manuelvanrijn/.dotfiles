require 'rake'

task :setup do
  `./setup_osx.sh`
  `./setup_software.sh`

  # symlink setup
  %w[asdf git node ruby vim zsh].each do |folder|
    DotfileHelper.scan_symlinks(folder)
  end

  # Setup sublime symlinks
  `mkdir -p ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/`
  `ln -s ~/.dotfiles/sublime3/Packages/User ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User`

  # Setup vscode symlinks
  `mkdir -p ~/Library/Application\ Support/Code/User/`
  `ln -s ~/.dotfiles/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json`
  `ln -s ~/.dotfiles/vscode/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json`
  `mkdir -p ~/Library/Application\ Support/Code/User/snippets`
  `ln -s ~/.dotfiles/vscode/snippets ~/Library/Application\ Support/Code/User/snippets`

  # Bundle config
  `mkdir -p ~/.bundle`
  `ln -s ~/.dotfiles/ruby/bundle/config ~/.bundle/config`
  `bundle config --global jobs $(($(sysctl -n hw.ncpu) - 1))`
end

task default: :setup

class DotfileHelper
  def self.scan_symlinks(dir)
    Dir.glob("#{dir}/*.symlink").each do |link|
      target = ".#{link.split('/').last.split('.symlink').last}"
      target = "~/#{target}"
      source = File.join(Dir.pwd, link)
      DotfileHelper.create(source, target)
    end
  end

  def self.create(source, target)
    DotfileHelper.create_link(source, target)
  end

  def self.create_link(source, target)
    if File.exist?(target) || File.symlink?(target)
      puts "SKIPPED: #{source} -> #{target}"
    else
      `ln -s #{source} #{target}`
    end
  end
end
