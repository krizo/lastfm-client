module Categories
  module Tracks
    def recent_tracks(params={})
      method = "user.getrecenttracks"
      response = make_request(method, params)['recenttracks']['track']
      response.reject! { |t| t['@attr'] } if params[:ignore_now_playing] == true
      response
    end

    def now_playing(params={})
      latest_track = recent_tracks({ignore_now_playing: false, limit: 1}).first
      if latest_track.has_key?('@attr')
        latest_track['@attr']['nowplaying'] ? latest_track : nil
      else
        nil
      end
    end
  end
end
