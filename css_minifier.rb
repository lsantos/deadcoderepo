#!/usr/bin/env ruby -wKU

require "tempfile"
require "fileutils"

minified_data = nil

def apply_substitutions(line)
  line.gsub(/(\n|\r)/, "").
  gsub(/\*.*?\*/, "").
  gsub(/\s+/, " ").
  gsub(/\s*:\s*/, ":").
  gsub(/\s*,\s*/, ",").
  gsub(/\s*\{\s*/, "{").
  gsub(/\s*\}\s*/, "}").
  gsub(/\s*;\s*/, ";").
  gsub(";}", "}").strip  
end


temp = Tempfile.new("working")

File.foreach(ARGV[0]) do |line|
  temp << apply_substitutions(line)
end

temp.close

FileUtils.cp(ARGV[0],"#{ARGV[0]}.bak")
FileUtils.mv(temp.path,ARGV[0])

puts "minification done"


