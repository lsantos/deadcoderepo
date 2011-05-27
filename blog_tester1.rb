require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'redis'

r = Redis.new
r.select("1")

base_urls = [
  "http://development.thescore.com/nba/",
  "http://www.thescore.com/nba/",
  "http://development.thescore.com/nhl/",
  "http://www.thescore.com/nhl/",
  "http://development.thescore.com/mlb/",
  "http://www.thescore.com/mlb/",
]

threads = []
base_urls.each do |base_url|
  threads << Thread.new do
    loop do
      url = "#{base_url}?#{rand(10000)}=#{rand(10000)}"
      doc = Nokogiri::HTML(open(url))

      xpath = "/html/body/div[2]/div[2]/div/div/div/div/ul/li/div[@class='stories']/ul/li[@class='blog_entry']/div[@class='post_with_thumbnail']"

      item = doc.xpath(xpath).first rescue nil

      success = !item.nil?
      puts "#{success} => #{url}"
      r.hincrby(base_url, success, 1)
      
      sleep(10)

    end
  end
end

threads.each(&:join)