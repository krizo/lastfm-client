module Categories
  module Tracks
    def recent_tracks(params={})
      method = "user.getrecenttracks"
      response = make_request(method, params)['recenttracks']['track']
      response.reject! { |t| t['@attr'] } if params[:ignore_now_playing] == true
      response
    end
  end
end
