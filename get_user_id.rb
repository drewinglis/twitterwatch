#!/usr/bin/ruby

require 'net/http'
require 'uri'
require 'rubygems'
require 'yajl'

screen_name = ARGV[0]

if !screen_name
  puts "Usage: screen_name"
  return
end

url = URI.parse("http://api.twitter.com/1/users/show.json?screen_name=#{screen_name}&include_entities=true")
response = Net::HTTP.start(url.host, url.port) {|http|
  http.get("#{url.path}?#{url.query}")
}
json = Yajl::Parser.parse(response.body, :symbolize_keys => true)
puts json[:id]
