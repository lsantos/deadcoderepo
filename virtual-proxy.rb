class VirtualProxy
  instance_methods.each do |name|
    undef_method name unless name =~ /^__/
  end
  
  def initialize(&creation_block)
    @creation_block = creation_block  
  end
  
  def subject
    @subject = @creation_block.call unless @subject
    @subject
  end
  
  def method_missing(meth, *args, &blk)
    if subject.respond_to?(meth)
      subject.send(meth, *args, &blk)
    else
      raise(NoMethodError, "undefined method #{meth} for #{subject.class}")
    end    
  end
  
end


v = VirtualProxy.new { Array.new }

v << 1

v << "222"

v.push 8

v.mais rescue # nomethoderror

puts(v)