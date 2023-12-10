#!/usr/bin/env ruby

require 'io/console'

dry = false
help = false
newonly = false
maxdepth = -1
exclude_lst = ""
exclude_lst_tmp = false
exclude_file = ""
exclude_file_tmp = false
verbose = false
progress = false
usage = "Usage: [ruby] #{$PROGRAM_NAME} [options] absolute_path_to_folder_to_add_to_autojump"

if ARGV.length < 1
  puts usage
  exit 1
end

new_ARGV = ARGV.select do |item|
  fnd = true
  if maxdepth == 0
    maxdepth = item.to_i
    if maxdepth < 0
      maxdepth = -1
    end
    fnd = false
  end
  if exclude_lst_tmp
    exclude_lst_tmp = false
    exclude_lst = item.strip
  end
  if exclude_file_tmp
    exclude_file_tmp = false
    if File.exist? item.strip and !File.directory? item.strip
      exclude_file = File.read(item.strip)
    end
  end
  if item=="-h" or item=="--help"
    help = true
    fnd = false
  end
  if item=="-d" or item=="--dry" or item=="--dry-run"
    dry = true
    fnd = false
  end
  if item=="-n" or item=="--new-only"
    newonly = true
    fnd = false
  end
  if item=="-m"
    maxdepth = 0
    fnd = false
  end
  if item=="-e" or item=="--exclude"
    exclude_lst_tmp = true
    fnd = false
  end
  if item=="-f" or item=="--file-exclude"
    exclude_file_tmp = true
    fnd = false
  end
  if item=="-v"
    verbose = true
    fnd = false
  end
  if item=="-p"
    progress = true
    fnd = false
  end
  fnd
end

if help
  puts usage
  puts "  Options:"
  puts "    -h or --help             - this help"
  puts "    -d or --dry or --dry-run - show only directories without adding to autojump"
  puts "    -n or --new-only         - add only new directories"
  puts "    -m                       - max directory scan depth, 0 - unlimited"
  puts "    -e or --exclude          - exclude dirs: -e dir1,dir2,dir3"
  puts "    -f or --file-exclude     - file of exludes dir list in format:"
  puts "                             dir1 - can be one word or absolute path"
  puts "                             dir2"
  puts "                             ..."
  puts "    -v                       - verbose"
  puts "    -p                       - show progress bar"
  exit 0
end

if maxdepth == -1
  maxdepth = 4096
end

if dry and new_ARGV.length < 1
  puts usage
  exit 1
end

ddir = new_ARGV[0]

if !File.directory? ddir
  puts "#{ddir} should be a directory"
  exit 2
end

autojump_bin = %x(which autojump).split.first.strip

if autojump_bin.empty?
  puts "Epty string #{autojump_bin}"
  exit 3
end

if ddir[0] != '/'
  puts "Path to directory #{ddir} must be absolute"
  exit 4
end

def IsDirExcl(excl, find)
  fnd = false
  excl.each do |item|
    if find.include? item
      fnd = true
      break
    end
  end
  fnd
end

def DirLists(dir1, max, cnt, excl, verbose)
  sub_dir_items = []
  if cnt >= max or IsDirExcl(excl, dir1)
    []
  else
    if verbose
      puts "Proceed dir #{dir1}"
    end
    list_of_items1 = Dir.entries(dir1).select do |entry|
      File.directory? File.join(dir1,entry) and !(entry =='.' || entry == '..') and (entry[0]!='.')
    end.map do |entry|
      File.join(dir1,entry)
    end
    list_of_items1.each do |item|
      if max > (cnt + 1) and File.exist? item and File.directory? item
        new_list_items = DirLists(item, max, cnt + 1, excl, verbose)
        sub_dir_items = sub_dir_items.append(*new_list_items)
      end
    end
    out = list_of_items1.select do |item|
      !IsDirExcl(excl, item)
    end
    if sub_dir_items.length > 0
      out.append(*sub_dir_items)
    end
    out
  end
end

list_excl = []

if exclude_lst != ""
  res1 = exclude_lst.split(",")
  list_excl.append(*res1)
end
if exclude_file != ""
  res1 = exclude_file.split
  list_excl.append(*res1)
end

puts "Prepeare directories list"

list_of_items = DirLists(ddir, maxdepth, 0, list_excl, verbose)

if newonly
  exec_str = "#{autojump_bin} --stat"
  result = %x("#{autojump_bin}" --stat)
  stopper = true
  result_prep = result.split("\n").select do |item|
    if item.include? "_______"
      stopper = false
    end
    stopper
  end.map do |item|
    item.split("\t")
  end.select do |item|
    item.length == 2
  end.map do |item|
    item[1]
  end
  res = list_of_items - result_prep
else
  res = list_of_items
end

cnt = 0
period = res.length / 100
if period == 0
  period = 1
  addprg = 100 / res.length
else
  addprg = 1
end
prg = 0

puts "Found #{res.length} directories"

res.each do |item|
  if dry
    puts "Will be added directory #{item} with command #{exec_str}"
  else
    if cnt % period == 0
      prg = prg + addprg if prg < 100
      prg = 100 if prg > 100
      if progress
        print "\rProgress: #{prg}% " + "#" * (prg/2)
      end
    end
    result = %x("#{autojump_bin}" --add '#{item}')
    if verbose
      puts "Added directory #{item} with command #{exec_str} with result #{result}"
    end
    cnt = cnt + 1
  end
end

if progress
  puts ""
end

exit 0
