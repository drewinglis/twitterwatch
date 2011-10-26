#!/usr/bin/ruby

require 'net/http'
require 'uri'
require 'rubygems'
require 'yajl'

user_id = "109645790"

user_ids = ARGV[0].split(",")
file_prefix = ARGV[1] ? ARGV[1] : "./"

if user_ids.length == 0
  puts "Usage: user_id[,user_id] [file_prefix]"
  return
end

user_ids.each do |user_id|
  url = URI.parse("http://api.twitter.com/1/users/show.json?user_id=#{user_id}&include_entities=true")
  response = Net::HTTP.start(url.host, url.port) {|http|
    http.get("#{url.path}?#{url.query}") # surely there is a better way to do this...
  }
  json = Yajl::Parser.parse(response.body, :symbolize_keys => true)
  json.merge!({:current_time => Time.now.to_s})
  File.open("#{file_prefix}#{user_id}.txt", "a+") do |f|
    f.syswrite("#{Yajl::Encoder.encode(response.body)}\n")
  end
  puts "successfully fetched data for #{json[:screen_name]}"
end
