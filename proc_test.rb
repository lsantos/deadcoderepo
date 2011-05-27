def make_proc
  n = 0
  Proc.new{ n += 1 }
end

c = make_proc
p c.call
p c.call

d = make_proc
p d.call
p c.call