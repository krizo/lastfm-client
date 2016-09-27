module Categories
  module Artists
    def artist_info(artist, params={})
      method = "artist.getinfo"
      make_request(method, { artist: artist}.merge(params))['artist']
    end

    def artist_tags(artist, params={})
      info = artist_info(artist, params)['tags']
      info ? info['tag'].map { |t| t['name'] } : []
    end
  end
end
