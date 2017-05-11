#!/usr/bin/env ruby
require 'fileutils'
require 'open-uri'
require 'openssl'

def dl_file(url, local_file)
  FileUtils.mkdir_p(File.dirname(local_file))
  File.open(local_file, "w") do |file|
    file << open(url, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}).read
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
  "git://github.com/tomtom/tcomment_vim.git",
  "git://github.com/vim-ruby/vim-ruby.git",
#  "git://github.com/fholgado/minibufexpl.vim.git",
#  "git://github.com/chrismetcalf/vim-yankring.git",
  "git://github.com/taq/vim-git-branch-info.git",
  "git://github.com/henrik/vim-indexed-search.git",
  "git://github.com/vhda/verilog_systemverilog.vim.git"
]

vim_org_scripts = [
]

other_scripts = [
  ['liberty','https://raw.githubusercontent.com/peter-d/dotfiles/master/.vim/syntax/liberty.vim', 'syntax'],
  ['liberty','https://raw.githubusercontent.com/peter-d/dotfiles/master/.vim/ftdetect/liberty.vim', 'ftdetect']
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
