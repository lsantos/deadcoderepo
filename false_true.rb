T = lambda { |a,b| a }
F = lambda { |a,b| b }
display = lambda { |boolean| boolean['true','false']}

p display.call T
p display.call F