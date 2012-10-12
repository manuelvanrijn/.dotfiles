require 'rake'

desc "Hook our dotfiles into system-standard positions."
task :install do
  # home = File.expand_path('~')

  # Dir['*'].each do |file|
  #   next if file =~ /install/
  #   target = File.join(home, ".#{file}")
  #   `ln -s #{File.expand_path file} #{target}`
  # end
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

      if File.exists?(target) || File.symlink?(target)
        puts "SKIPPED: #{source} -> #{target}"
      else
        `cmd.exe /C mklink /D \"#{target}\" \"#{source}\"`
      end
    end
  elsif OS.mac?
    sublime_data_folder = File.join('~', 'Library', 'Application Support', 'Sublime Text 2')

    if Dir.exists?(sublime_data_folder)
      puts "Sublime Text 2 wasn't installed"
      return
    end

    Dir.foreach('sublime2/') do | folder |
      next if folder == '.' or folder == '..'

      source = File.join(Dir.pwd, 'sublime2', folder)
      target = File.join(sublime_data_folder, folder)

      if File.exists?(target) || File.symlink?(target)
        puts "SKIPPED: #{source} -> #{target}"
      else
        `ln -s #{source} #{target}`
      end
    end
  end
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
