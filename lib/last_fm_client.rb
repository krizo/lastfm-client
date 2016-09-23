require 'httparty'
require 'pry'

class LastfmClient
  include HTTParty
  base_uri "ws.audioscrobbler.com"

  def initialize(public_api_key, last_fm_user=nil)
    @api_key = public_api_key
    @user = last_fm_user
  end

  def base_path
    "/2.0/?api_key=#{@api_key}&format=json"
  end

  def recent_tracks(params={})
    method = "user.getrecenttracks"
    user = params[:user] || @user
    options = {
      user: user,
      method: method
    }
    response = handle_response do
      self.class.get(base_path, query: options.merge(params))
    end
    response['recenttracks']['track']
  end

  def handle_response
    response = yield
    case response.code.to_i
    when 200, 201, 204
      response
    else
      raise "#{response.code}, #{response.message}"
    end
  end
end
