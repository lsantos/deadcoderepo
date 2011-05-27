#!/usr/bin/env ruby  
%w(yaml pp).each { |dep| require dep }  

obj = YAML::load(DATA)  
  
pp obj  
  
__END__
  
---  
-  
  name: Adam  
  age: 28  
  admin: true  
-  
  name: Maggie  
  age: 28  
  admin: false