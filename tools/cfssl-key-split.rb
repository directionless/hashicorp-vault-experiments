#!/usr/bin/env ruby
# cfssl spits out a json wad. We want to split it to files.
# This is a glorified oneliner.
require 'json'
d = JSON.parse(STDIN.read)
d.each do |n,v|
  open([ARGV[0],n].join("."),"w") do |f|
    f.puts v
  end
end
