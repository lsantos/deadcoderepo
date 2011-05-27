# coding: ISO-8859-1 
require 'rubygems'
require 'httparty'
require 'json'

response = HTTParty.get("http://www.google.com/uds/GlangDetect", :query => {
  :v => '1.0',
  :q => "Cachaça"
})

p JSON.parse(response.body)["responseData"]
