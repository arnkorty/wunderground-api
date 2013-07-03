# -*- encoding: utf-8 -*-
require '../lib/wunderground-api'
api_key = YAML.load_file("api_key.yml")["api_key"]
p api_key
Wunderground::Base
p Wunderground::Base.methods.sort
Wunderground::Base.config do |c|
  c.lang    = "CN"
  c.format  = "json"
  c.api_key = api_key
end
wapi = Wunderground::Base.new
p wapi.history_for("20130202",:location=>'JS/Nanjing',:result_format=>:Hash)
p wapi.hourly_for(:location=>['JS','Nanjing'],:result_format=>'url') #["response"]["error"]

#class MyAPI <  Wunderground::Base.new
#  def initialize()
#
#  end
#end

myapi =  Wunderground::Base.new(lang: "CN",format:"json",api_key:api_key)
p myapi.alerts_for(:location=>["IA","Des_Moines"],:result_format=>:url)
p myapi.alerts_for(:location=>["IA","Des_Moines"])
p myapi.planner_for("07010731",:location=>["IA","Des_Moines"],:result_format=>:url)
p myapi.planner_for("07010731",:location=>"Nanjing",:result_format=>:Hash)
