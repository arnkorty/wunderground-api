require 'open-uri'
require 'uri'
require 'json'
class MissingAPIKey < RuntimeError; end
class APIError < RuntimeError; end
module Wunderground
  module MethodModule
    attr_accessor :api_key,:lang ,:format  ,:result_format
    def config
      yield(self)
    end
  end
  module Api
  BASE_URL = 'http://api.wunderground.com/api'
  AUTOC_URL = 'http://autocomplete.wunderground.com/aq?'
  DEFAULT_FORMAT = 'json'
    def self.included(base)
       base.extend MethodModule
    end

  def get_url(feature,query_type,options={})
    raise MissingAPIKey if @api_key.nil?
    @result_format = options.delete(:result_format)
    params= []
    options.each do |k,value|
      params << "#{k}=#{value}"
    end
    URI::escape("#{BASE_URL}/#{@api_key}/#{feature}/#{query_type}#{params.length > 0 ? '?'+ params.join("&"):''}")
  end

  def get_data(url)
    case (@result_format || 'url').to_s
      when 'url'
        url
      when 'json','String'
        open(url).read
      when 'Hash'
        JSON.parse(open(url).read)
      when 'gif'
        url
    end
  end

  def lang
    @lang
  end
  def api_key
    @api_key
  end
  def format
    @format
  end
  def history_for(date,options={})
    date = String === date ? date : date.strftime("%Y%m%d")
    raise  APIError,"date format error" unless date =~ /^\d{4}[01]\d[0-3]\d$/
    send("url_require","history_#{date}",options)
  end

  def planner_for(dd,options={})
    raise APIError,'planner date format error,must be MMDDMMDD' unless dd =~ /^[01]\d[0-3]\d[01]\d[0-3]\d$/
    send("url_require","planner_#{dd}",options)
  end

  def get_query_type(options={})
    t = options.delete(:q) || 'q'
    if t == 'q'
      #q_type = t
      location = options.delete(:location) || options.delete(:l)
      unless location.nil?
        # if location =~ /^[a-bA-Z\/\_]+$/
          if String === location 
            if  location =~ /\//  || location =~ /\:/
              t = t + '/' + location
            else
              #p JSON.parse(open(URI::escape(AUTOC_URL+"query=#{location}")).read)
              #p open(URI::escape(AUTOC_URL+"query=#{location}")).read
              json =  JSON.parse(open(URI::escape(AUTOC_URL+"query=#{location}")).read)

              t = t + '/zmw:' + json["RESULTS"][0]["zmw"]
            end
          elsif Hash === location
            params = []
            location.each do |key,value|
              params << "#{key}=#{value}"
            end
            t = t + '/zmw:' + JSON.parse(open(URI::escape(AUTOC_URL+"#{params.join("&")}")).read)
          elsif Array === location
            t = t + '/' + location.join('/')
          end
      end
    end

      "#{t}.#{options[:format] || @format}"
  rescue => e
    raise APIError ,"location error  #{e}"

  end

  protected
  def url_require(feature,options)
    query_type = get_query_type(options)
    url       = get_url(feature,query_type,options)
    get_data(url)
  end

  def method_missing(method,*args)
    super(method, *args) unless method_missing_match?(method)
    feature = method.to_s.sub(/_for$/,'').gsub(/and/,'/')
    raise APIError,'must had params'  if args.nil?
    raise APIError,'params must be Hash' unless Hash === args.first
    url_require(feature,args.first)
  end
  private
  def method_missing_match?(method)
    method.to_s.end_with?("_for")
  end
  end
end