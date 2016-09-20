require 'rake'

task :setup do
  # symlink setup
  %w(git node ruby vim zsh).each do |folder|
    DotfileHelper.scan_symlinks(folder)
  end

  # sublime 3
  sublime_data_folder = File.join('~', 'Library', 'Application Support', 'Sublime Text 3')

  if Dir.exist?(sublime_data_folder)
    puts "Sublime Text 3 wasn't installed"
    return
  end

  source = File.join(Dir.pwd, 'sublime3', 'Packages', 'User').gsub(' ', '\ ')
  target = File.join(sublime_data_folder, 'Packages', 'User').gsub(' ', '\ ')

  DotfileHelper.create(source, target)

  # .bundle/config
  `mkdir -p ~/.bundle`
  source = File.join(Dir.pwd, 'ruby', 'bundle', 'config').gsub(' ', '\ ')
  target = File.join('~', '.bundle', 'config').gsub(' ', '\ ')

  DotfileHelper.create(source, target)
end

task default: :setup

class DotfileHelper
  def self.scan_symlinks(dir)
    Dir.glob("#{dir}/*.symlink").each do |link|
      target = ".#{link.split('/').last.split('.symlink').last}"
      target = "~/#{target}"
      DotfileHelper.create(link, target)
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
