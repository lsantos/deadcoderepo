require 'rubygems'
require 'httparty'
require 'json'

class LanguageDetector
  URL = "http://www.google.com/uds/GlangDetect"

  def initialize(text)
    @text = text
  end

  # Returns the language if it can be detected, otherwise nil
  def language
    response = HTTParty.get(URL, :query => {:v => '1.0', :q => @text})

    return nil unless response.code == 200

    info = JSON.parse(response.body)["responseData"]

    return info['isReliable'] ? info['language'] : nil
  end
end

puts LanguageDetector.new("Sgwn i os yw google yn deall Cymraeg?").language