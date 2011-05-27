class Expando
  
  def initialize(hash=nil)
    define_attributes(hash) unless hash.blank?
    yield self if block_given? 
  end
  
  def metaclass
    class << self
      self
    end
  end

  def define_attributes(hash)
    hash.each_pair { |key, value|
      metaclass.send :attr_accessor, key
      send "#{key}=".to_sym, value
    }
  end
  
  def method_missing(meth, *args, &blk)
    if meth.to_s[-1..-1] == "="
      m = meth.to_s[0..-2].to_sym
      metaclass.send :attr_accessor, m
      send "#{m}=".to_sym, args[0]
    elsif meth.to_s[-1..-1] == "?"
      metaclass.send(:define_method, meth.to_sym) { true }
    end    
  end
  
end