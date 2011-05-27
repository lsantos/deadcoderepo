class Integer
  def my_times
    while (c ||= 0; c <= self)
      numbers ||= []
      numbers << c
      c += 1
    end
    numbers.my_each{|n| yield n if block_given?}
    self
  end
end

class Array
  def my_each
    c = 0
    until c == size
      yield(self[c])
      c += 1
    end
    self
  end
  
  # def my_each
  #   size.my_times do |i|
  #     yield self[i]
  #   end
  #   self
  # end
end

puts 4.my_times{|n| p n}
puts 4.times{|n| p n}
# puts([1,2,3,4].my_each {|item| item})


