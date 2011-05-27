class A
  undef_method :is_a?
end

class B < A
  def is_a?(blah)
    p :in_isa
    super
  end

  def method_missing(*)
    false
  end
end

b = B.new

p b.is_a?(B)
