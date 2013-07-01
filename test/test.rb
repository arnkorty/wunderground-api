require '../lib/wunderground-api'
Wunderground::Base
p Wunderground::Base.methods.sort
Wunderground::Base.config do |c|
  c.lang    = "CN"
  c.format  = "json"
end
wapi = Wunderground::Base.new
p wapi.history_for("20130202",:location=>'JS/Nanjing',:result_format=>:json)
p wapi.hourly_for(:location=>['JS','Nanjing'],:result_format=>'Hash')