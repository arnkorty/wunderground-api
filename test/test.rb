#coding: utf-8
require '../lib/wunderground-api'
Wunderground::Base
p Wunderground::Base.methods.sort
Wunderground::Base.config do |c|
  c.api_key = "a7d94438d2ed8711"
  c.lang    = "CN"
  c.format  = "json"
end
wapi = Wunderground::Base.new
p wapi.history_for("20130202",:location=>'Nanjing',:result_format=>:json)
p wapi.hourly_for(:location=>"beijing",:result_format=>'Hash')