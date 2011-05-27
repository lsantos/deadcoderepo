begin
  puts "attempting"
  4 / 0
rescue
  retry if _r = (_r || 0) + 1 and _r < 4
  raise
end

