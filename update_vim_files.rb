#!/usr/bin/env ruby
require 'fileutils'
require 'open-uri'

def dl_file(url, local_file)
  FileUtils.mkdir_p(File.dirname(local_file))
  File.open(local_file, "w") do |file|
    file << open(url).read
  end
end

vim_dir = File.dirname(__FILE__)
bundles_dir = File.join(vim_dir, "bundle")

# update pathogen only
pathogen_local_dir = "vim-pathogen"
FileUtils.rm_rf(pathogen_local_dir)
`git clone git://github.com/paulnicholson/vim-pathogen.git #{pathogen_local_dir}`
FileUtils.mkdir_p('autoload')
FileUtils.mv(File.join(pathogen_local_dir, 'pathogen.vim'), 'autoload')
FileUtils.rm_rf(pathogen_local_dir)

# "git://github.com/tsaleh/vim-align.git",
# "git://github.com/vim-scripts/doxygen-support.vim.git",
# "git://github.com/tpope/vim-fugitive.git",
# "git://github.com/scrooloose/nerdtree.git",
git_bundles = [ 
  "git://github.com/msanders/snipmate.vim.git",
  "git://github.com/tpope/vim-git.git",
  "git://github.com/tpope/vim-repeat.git",
  "git://github.com/tpope/vim-surround.git",
  "git://github.com/tomtom/tcomment_vim.git",
  "git://github.com/vim-ruby/vim-ruby.git",
#  "git://github.com/fholgado/minibufexpl.vim.git",
  "git://github.com/chrismetcalf/vim-yankring.git",
  "git://github.com/taq/vim-git-branch-info.git",
  "git://repo.or.cz/vcscommand",
]

vim_org_scripts = [
  ["IndexedSearch", "7062",  "plugin", false],
  ["tcl", "7049",  "syntax", false],
]

other_scripts = [
  ['txt2tags','http://txt2tags.org/tools/txt2tags.vim', 'syntax']
]

FileUtils.cd(bundles_dir)

puts "Trashing everything (lookout!)"
Dir["*"].each {|d| FileUtils.rm_rf d }

git_bundles.each do |url|
  dir = url.split('/').last.sub(/\.git$/, '')
  puts "  Unpacking #{url} into #{dir}"
  `git clone #{url} #{dir}`
  FileUtils.rm_rf(File.join(dir, ".git"))
end

vim_org_scripts.each do |name, script_id, script_type, zipped|
  puts "  Downloading #{name}"
  url = "http://www.vim.org/scripts/download_script.php?src_id=#{script_id}"
  if zipped
    puts "ERROR: no support for zipped files yet"
    next
  else
    local_file = File.join(name, script_type, "#{name}.vim")
    dl_file(url, local_file)
  end
end

other_scripts.each do |name, url, script_type|
  puts "  Downloading #{name}"
  local_file = File.join(name, script_type, "#{name}.vim")
  dl_file(url, local_file)
end
