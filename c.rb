class C
  def some_method
    puts "self here at the method is #{self}"
    @v = "some var method"
    puts "printing v in the method #{@v}"
    puts "class value v var #{self.class.instance_variable_get(:@v)}"
  end
  puts "self here at the class body is #{self}"
  @v = "some var body"
  puts "printing v in the class body #{@v}"
end

C.new.some_method
