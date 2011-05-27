#! /usr/bin/ruby

module NumericExt

  def compare(other,scale = 2)
    base = 0.5
    scale.times { base = base / 10 }
    ((other - self).abs) <= base
  end

end

a = 11.00
b = 11.00

a.extend(NumericExt)

p a.compare(b)

