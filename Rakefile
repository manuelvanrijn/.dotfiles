require 'rake'

task :setup do
  `./setup_osx.sh`
  `./setup_software.sh`

  # symlink setup
  %w[asdf git node ruby vim zsh].each do |folder|
    DotfileHelper.scan_symlinks(folder)
  end

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
