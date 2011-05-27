cat = "miaow"

def cat.speak
  puts self
end

cat.speak

$a = [1,2,3,4,5]

def test
  $a.find_all{|a| yield a}
end

puts test {|a| a > 1}



unless true && false
 p "unless code"
end