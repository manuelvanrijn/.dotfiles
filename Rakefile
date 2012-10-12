require 'rake'

task :default => :install

desc "Hook our dotfiles into system-standard positions."
task :install do
  puts "Please specify what part you like to install"
  puts ""
  puts "Options:"
  puts "  env       (win)"
  puts "  git       (win/osx)"
  puts "  ruby      (osx)"
  puts "  sublime2  (win/osx)"
  puts "  zsh       (osx)"
end

desc "Enviroment installation scripts"
task :env do
  if OS.windows?
    # Set the $DOTFILES Enviroment variable
    if ENV['DOTFILES'].nil?
      `cmd.exe /C setx DOTFILES #{Dir.pwd}`
    end
  end
end

desc "Git installation script"
task :git do
  if OS.windows?
    DotfileHelper.scan_symlinks("git")
    DotfileHelper.scan_symlinks("git/win")
  elsif OS.mac?
    DotfileHelper.scan_symlinks("git")
    DotfileHelper.scan_symlinks("git/osx")
  end
end

desc "ruby installation script"
task :ruby do
  if OS.windows?
    puts "TODO"
  elsif OS.mac?
    DotfileHelper.scan_symlinks("ruby")
  end
end

desc "Sublime Text 2 installation script"
task :sublime2 do
  if OS.windows?
    sublime_data_folder = File.join(ENV['HOMEDRIVE'], ENV['HOMEPATH'], 'AppData', 'Roaming', 'Sublime Text 2').gsub(File::SEPARATOR, File::ALT_SEPARATOR || File::SEPARATOR)

    if Dir.exists?(sublime_data_folder)
      puts "Sublime Text 2 wasn't installed"
      return
    end

    Dir.foreach('sublime2/') do | folder |
      next if folder == '.' or folder == '..'
      source = File.join(Dir.pwd, 'sublime2', folder).gsub(File::SEPARATOR, File::ALT_SEPARATOR || File::SEPARATOR)
      target = File.join(sublime_data_folder, folder).gsub(File::SEPARATOR, File::ALT_SEPARATOR || File::SEPARATOR)

      DotfileHelper.create(source, target)
    end
  elsif OS.mac?
    sublime_data_folder = File.join('~', 'Library', 'Application Support', 'Sublime Text 2')

    if Dir.exists?(sublime_data_folder)
      puts "Sublime Text 2 wasn't installed"
      return
    end

    Dir.foreach('sublime2/') do | folder |
      next if folder == '.' or folder == '..'

      source = File.join(Dir.pwd, 'sublime2', folder).gsub(' ', '\ ')
      target = File.join(sublime_data_folder, folder).gsub(' ', '\ ')

      DotfileHelper.create(source, target)
    end
  end
end

desc "zsh installation script"
task :zsh do
  return unless OS.mac?
  DotfileHelper.scan_symlinks("zsh")
end

# git push on commit
#`echo 'git push' > .git/hooks/post-commit`
#`chmod 755 .git/hooks/post-commit`


module OS
  def OS.windows?
    (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
  end

  def OS.mac?
   (/darwin/ =~ RUBY_PLATFORM) != nil
  end

  def OS.unix?
    !OS.windows?
  end

  def OS.linux?
    OS.unix? and not OS.mac?
  end
end

module DotfileHelper
  def DotfileHelper.scan_symlinks(dir)
    Dir.glob("#{dir}/*.symlink").each do | link |
      target = ".#{link.split('/').last.split('.symlink').last}"
      if OS.mac?
        target = "~/#{target}"
      elsif OS.windows?
        home_dir = File.join(ENV['HOMEDRIVE'], ENV['HOMEPATH'])
        target = File.join(home_dir, target)
      end
      DotfileHelper.create(link, target)
    end
  end

  def DotfileHelper.create(source, target)
    DotfileHelper.create_osx(source, target) if OS.mac?
    DotfileHelper.create_win(source, target) if OS.windows?
  end

  def DotfileHelper.create_osx(source, target)
    if File.exists?(target) || File.symlink?(target)
      puts "SKIPPED: #{source} -> #{target}"
    else
      `DotfileHelper #{source} #{target}`
    end
  end

  def DotfileHelper.create_win(source, target)
    source = source.gsub(File::SEPARATOR, File::ALT_SEPARATOR || File::SEPARATOR)
    target = target.gsub(File::SEPARATOR, File::ALT_SEPARATOR || File::SEPARATOR)

    if File.exists?(target) || File.symlink?(target)
      puts "SKIPPED: #{source} -> #{target}"
    else
      if File.directory?(source)
        `cmd.exe /C mklink /D \"#{target}\" \"#{source}\"`
      else
        `cmd.exe /C mklink /H \"#{target}\" \"#{source}\"`
      end
    end
  end
end
