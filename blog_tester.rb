require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'redis'

r = Redis.new
r.select("1")

loop do
  doc = Nokogiri::XML(open("http://blogs.thescore.com/tbj/feed/?#{rand(1000)}=#{rand(1000)}"))
  item = doc.xpath(".//channel//item[title='The Lakers need marriage counseling']//media:thumbnail").first rescue nil
  url = item.nil? ? "blank" : item.attributes["url"]
  puts url
  r.sadd("urls", url)
  sleep(2)
end



