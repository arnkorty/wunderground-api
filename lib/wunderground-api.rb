require "wunderground-api/version"
require "wunderground-api/wunderground"
module Wunderground
  class Base
    include Wunderground::Api
    attr_accessor  :api_key,:lang ,:format  ,:result_format
    def initialize(opts={})
        @api_key = opts[:api_key] || self.class.api_key
        @lang = opts[:lang] || self.class.lang
        @format = opts[:format] || self.class.format
        @result_format = opts[:result_format] || self.class.result_format
    end
    #include Wunderground::MethodModule

    # Your code goes here...
  end
end
