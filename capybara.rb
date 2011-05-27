require 'rubygems'
require 'capybara/dsl'
require 'capybara'



Capybara.current_driver = :selenium
Capybara.app_host = 'http://www.google.com'
Capybara.visit('/')
Capybara.fill_in('q', :with => 'John')
Capybara.find_button('Google Search').click
Capybara.find_link('l').visible?

# Capybara.save_and_open_page