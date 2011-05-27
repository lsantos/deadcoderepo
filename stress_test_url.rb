#!/usr/bin/env ruby 
require 'optparse'
require 'ostruct'

urls = %w(
          http://development.thescore.com/nhl/events/2820-philadelphia-at-buffalo/box_score 
          http://development.thescore.com/mlb/events/5795/box_score 
          http://development.thescore.com/ncaaf/events/3118/box_score
          http://development.thescore.com/nba/7275-cleveland-at-boston/box_score
          http://development.thescore.com/ncaab/events/14267/box_score
          http://development.thescore.com/
          http://development.thescore.com/cfl/events/3821/box_score
          http://development.thescore.com/epl/events/4147/box_score
          http://development.thescore.com/nba
          http://development.thescore.com/nba/standings
         )
options = OpenStruct.new
options.threads = 10
options.time = 10

opts = OptionParser.new do |opts|
  opts.banner = "Usage: stress_test_url.rb --threads [number of threads] 
                                           --time [amount of time]"
  opts.separator ""
  opts.separator "Specific options:"         
  
  opts.on("--threads [number]",
         Integer,
          "Number of threads that will hammer the server"
                  ) do |number|
   options.threads = number                  
  end

  opts.on("--time [time]",
           Integer,
            "Amount of time that the threads will hammer the server"
                  ) do |time|
   options.time = time                 
  end
  
  opts.on_tail("-h", "--help", "Show this message") do
    puts opts
    exit
  end

  # Another typical switch to print the version.
  opts.on_tail("--version", "Show version") do
    puts "Version 0.5"
    exit
  end
end

begin
  opts.parse!(ARGV)
rescue
  puts "#{$!.exception.message}"
  exit
end  
         
options.threads
options.time

p options.threads, options.time
commands = []

urls.shuffle.each do |url|
  system("/usr/sbin/ab -kc #{options.threads} -t #{options.time} #{url}?n=#{rand}") 
end

puts "stress test complete"
