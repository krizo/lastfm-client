module Categories
  module Tracks
    def recent_tracks(params={})
      response = get_recent_tracks(params)['track']
      response.reject! { |t| t['@attr'] } if params[:ignore_now_playing] == true
      response
    end

    def now_playing(params={})
      latest_track = get_recent_tracks['recenttracks']['track'].first
      if latest_track.has_key?('@attr')
        latest_track['@attr']['nowplaying'] ? latest_track : nil
      else
        nil
      end
    end

    def recent_tracks_attributes(params)
      get_recent_tracks(params)['@attr']
    end

    private
    def get_recent_tracks(params)
      method = "user.getrecenttracks"
      make_request(method, params)['recenttracks']
    end
  end
end
