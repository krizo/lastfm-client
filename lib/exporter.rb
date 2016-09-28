require 'csv'
require 'last_fm_client'

class CsvExporter
  attr_reader :output_file, :exported_records
  include Categories::Tracks
  include Categories::Artists

  def initialize(last_fm_client, output_file)
    @client = last_fm_client
    @output_file = output_file
  end

  def export_for_timeframe(output_file, from_time, to_time=Time.now, params={})
    params = init_export(params)
    params[:from], params[:to] = from_time, to_time
    pages = params[:end_page] || @client.recent_tracks_attributes(params)['totalPages'].to_i
    current_page = params[:start_page] || 1
    while current_page <= pages
      options = {
        from: from_time,
        to: to_time,
        ignore_now_playing: true,
        page: current_page,
        limit: params[:limit]
      }
      tracks = @client.recent_tracks(options)
      save_tracks(tracks)
      current_page += 1
    end
  end

  def export_recent_tracks(output_file, params={})
    params = init_export(params)
    pages = params[:end_page] || @client.recent_tracks_attributes(params)['totalPages'].to_i
    current_page = params[:start_page] || 1
    while current_page <= pages
      params[:page] = current_page
      params[:ignore_now_playing] = true
      tracks = @client.recent_tracks(params)
      save_tracks(tracks)
      current_page += 1
    end
  end

  private
  def init_headers(headers=[])
    CSV.open(@output_file, 'w') do |csvfile|
      csvfile << headers
    end
  end

  def init_export(params={})
    @exported_records = 0
    params[:limit] ||= 200
    headers = [
      'user',
      'timestamp',
      'date',
      'time',
      'artist',
      'album',
      'track_name',
      'duration',
      'listeners',
      'playcount',
      'user_playcount',
      'tags'
    ]
    init_headers(headers)
    params
  end

  def save_tracks(tracks)
    tracks.each do |track|
      CSV.open(@output_file, 'a') do |out|
        artist = track['artist']['#text']
        track_name = track['name']
        track_info = @client.track_info(artist, track_name)
        duration = track_info ? track_info['duration'] : nil
        listeners = track_info ? track_info['listeners'] : nil
        playcount = track_info ? track_info['playcount'] : nil
        user_playcount = track_info ? track_info['userplaycount'] : nil
        tags = if track_info
          if !track_info['toptags']['tag'].empty?
            track_info['toptags']['tag'].map { |tag| tag['name']}
          else
            artist_tags = @client.artist_tags(artist)
          end
        else
          artist_tags = @client.artist_tags(artist)
        end
        row = {
          user: @client.user,
          timestamp: track['date']['uts'],
          date: track['date']['#text'].split(',')[0].strip,
          time: track['date']['#text'].split(',')[1].strip,
          artist: artist.gsub('+', ' '),
          album: track['album']['#text'].gsub('+', ' '),
          track_name: track_name.gsub('+', ' '),
          duration: duration,
          listeners: listeners,
          playcount: playcount,
          user_playcount: user_playcount,
          tags: tags.join(";")
        }
        out << row.values
        @exported_records += 1
      end
    end
  end
end
