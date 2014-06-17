require 'rake'

task :default => :install

desc "Hook our dotfiles into system-standard positions."
task :install do
  puts "Please specify what part you like to install"
  puts ""
  puts "Options:"
  puts "  git"
  puts "  ruby"
  puts "  sublime2"
  puts "  vim"
  puts "  zsh"
end

desc "Git installation script"
task :git do
  DotfileHelper.scan_symlinks("git")
end

desc "ruby installation script"
task :ruby do
  DotfileHelper.scan_symlinks("ruby")
end

desc "Sublime Text 2 installation script"
task :sublime2 do
  sublime_data_folder = File.join('~', 'Library', 'Application Support', 'Sublime Text 2')

  if Dir.exists?(sublime_data_folder)
    puts "Sublime Text 2 wasn't installed"
    return
  end

  source = File.join(Dir.pwd, 'sublime2', 'Packages', 'User').gsub(' ', '\ ')
  target = File.join(sublime_data_folder, 'Packages', 'User').gsub(' ', '\ ')

  DotfileHelper.create(source, target)
end

desc "Sublime Text 3 installation script"
task :sublime3 do
  sublime_data_folder = File.join('~', 'Library', 'Application Support', 'Sublime Text 3')

  if Dir.exists?(sublime_data_folder)
    puts "Sublime Text 3 wasn't installed"
    return
  end

  source = File.join(Dir.pwd, 'sublime3', 'Packages', 'User').gsub(' ', '\ ')
  target = File.join(sublime_data_folder, 'Packages', 'User').gsub(' ', '\ ')

  DotfileHelper.create(source, target)
end

desc "vim installation script"
task :vim do
  DotfileHelper.scan_symlinks("vim")
end

desc "zsh installation script"
task :zsh do
  DotfileHelper.scan_symlinks("zsh")
end

# git push on commit
#`echo 'git push' > .git/hooks/post-commit`
#`chmod 755 .git/hooks/post-commit`

module DotfileHelper
  def DotfileHelper.scan_symlinks(dir)
    Dir.glob("#{dir}/*.symlink").each do | link |
      target = ".#{link.split('/').last.split('.symlink').last}"
      target = "~/#{target}"
      DotfileHelper.create(link, target)
    end
  end

  def DotfileHelper.create(source, target)
    DotfileHelper.create_link(source, target)
  end

  def DotfileHelper.create_link(source, target)
    if File.exists?(target) || File.symlink?(target)
      puts "SKIPPED: #{source} -> #{target}"
    else
      `ln -s #{source} #{target}`
    end
  end
end
