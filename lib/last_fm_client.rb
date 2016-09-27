require 'httparty'
require 'pry'
require 'categories/tracks'

class LastfmClient
  include HTTParty
  include Categories::Tracks

  base_uri "ws.audioscrobbler.com"

  def initialize(public_api_key, last_fm_user=nil)
    @api_key = public_api_key
    @user = last_fm_user
  end

  def base_path
    "/2.0/?api_key=#{@api_key}&format=json"
  end

  private
  def handle_response
    response = yield
    case response.code.to_i
    when 200, 201, 204
      response
    else
      raise "#{response.code}, #{response.message}, #{response['message']}"
    end
  end

  def make_request(method, options)
    options[:user] ||= @user
    options[:method] = method
    options[:from] = options[:from].to_time.to_i if options[:from]
    options[:to] = options[:to].to_time.to_i if options[:to]
    handle_response do
      self.class.get(self.base_path, query: options)
    end
  end
end
