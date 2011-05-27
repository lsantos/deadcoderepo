#! /usr/bin/ruby

Numeric.module_eval do
  define_method(:compare) do |*params|
    other,scale = *params

    if other.nil?
      raise ArgumentError, "other number is required as argument"
    end

    scale       ||= 2
    base          = 0.5
    scale.times { base = base / 10 }
    ((other - self).abs) <= base

    end
  end

a = 12.00
b = 12.09

p a.compare b

