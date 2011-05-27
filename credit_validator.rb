#!/usr/bin/env ruby -wKU

cc = "4520880012048896"

d = []

cc.each_with_index do |digit, index|
  d << (index % 2 ==0 ? digit = digit.to_i * 2 : digit.to_i)
end

r = d.first.to_i / 10

puts "result -> #{r}"