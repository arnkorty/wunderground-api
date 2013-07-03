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
    set_lang = @lang ? "/lang:#{@lang}" : ""
    if @lang
      URI::escape("#{BASE_URL}/#{@api_key}/#{feature}#{set_lang}/#{query_type}#{params.length > 0 ? '?'+ params.join("&"):''}")
    else
      URI::escape("#{BASE_URL}/#{@api_key}/#{feature}/#{query_type}#{params.length > 0 ? '?'+ params.join("&"):''}")
    end

  end

  def get_data(url)
    case (@result_format || DEFAULT_FORMAT).downcase.to_s
      when 'url'
        url
      when 'json','string',"hash"
        json = open(url).read
        h = JSON.parse(json)
        if h["response"]["error"]
          case  h["response"]["error"]["type"]
            when "keynotfound"
              raise  MissingAPIKey, "#{ h["response"]["error"]["type"]} =>#{ h["response"]["error"]["description"]}"
            else
              raise  APIError, "#{ h["response"]["error"]["type"]} =>#{ h["response"]["error"]["description"]}"
          end
        end
        (@result_format || DEFAULT_FORMAT).downcase.to_s == "hash" ? h : json
      when 'gif',"jpg","png","jpeg"
        url
    end
  rescue => e
    raise e.class,e.to_s
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
        if String === location
          t = t + '/' + location
        elsif Array === location
          t = t + '/' + location.join('/')
        end
      end
    end
    t =~ /\.\w/  ?  t : "#{t}.#{options[:format] || @format}"

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