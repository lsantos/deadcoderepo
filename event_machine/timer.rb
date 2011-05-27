#!/usr/bin/ruby

require 'rubygems'
require 'eventmachine'

EventMachine.run do
    EM.add_periodic_timer(1) { puts "Tick ..." }

    EM.add_timer(3) do
        puts "I waited 3 seconds"
        EM.stop_event_loop
    end
end

puts "All done."