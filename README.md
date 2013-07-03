# Wunderground::Api

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'wunderground-api' ,git:https://github.com/arnkroty/wunderground-api

And then execute:

    $ bundle

## Usage

TODO: Write usage instructions here
```ruby
#as a default config
Wunderground::Base.config do |c|
  c.lang    = "lang"
  c.format  = "json"
  c.api_key = api_key
  c.result_format = "json"
end
myapi = Wunderground::Base.new
#or
myapi = Wunderground::Base.new(lang:your_language,format:format,api_key:your_api_key)

myapi.history_for("20130202",:location=>'JS/Nanjing',:result_format=>:Hash)
 #as a Hash {"response"=>{"version"=>"0.1", "termsofService"=>"http://www.wunderground.com/weather/api/d/terms.html", ...
myapi.history_for("20130202",:location=>'JS/Nanjing')
 #default as json  "\n{\n\t\"response\": {\n\t\t\"version\": \"0.1\"\n\t\t,\"termsofS ...
wapi.hourly_for(:location=>['JS','Nanjing'],:result_format=>'url') #get the api url
```
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
