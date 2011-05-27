
h = Hash.new {|k,v| Array.new }
puts "hey"
h[:h] = "l"
puts(h[:h])
puts(h['k'])
