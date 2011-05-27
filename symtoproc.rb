class Symbol
  def to_proc
    puts "using my to_proc"
    Proc.new {|object| object.send self }
  end
  
end