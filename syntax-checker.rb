#!/usr/bin/env ruby 

flag = false

Dir["{app,config,lib}/**/*/*.rb"].each do |file|
	  result = `ruby -c #{file}`
	 
	  if $? != 0
	    puts result
	    flag = true
	  end
	  
end

Dir["app/views/**/*/*.haml"].each do |file|
    result = `haml -c #{file}`
   
    if $? != 0
      puts "#{result} #{file}"
      flag = true
    end
    
end

exit 1 if flag