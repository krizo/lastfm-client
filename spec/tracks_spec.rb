require "spec_helper"

describe "LastfmClient" do
  before(:all) do
    @client = LastfmClient.new(ENV['API_KEY'], 'kriz_z')
  end


  describe ".recent_tracks" do
    before(:each) do
      @params = { ignore_now_playing: true }
    end
    let(:actual_attributes) { @client.recent_tracks_attributes(@params) }

    it "returns recent 50 tracks by default" do
      expect(@client.recent_tracks(@params).count).to eq 50
      expect(@client.recent_tracks_attributes(@params)['perPage'].to_i).to eq 50
    end

    it "returns recent with limit 3" do
      @params[:limit] = 3
      expect(@client.recent_tracks(@params).count).to eq 3
      expect(@client.recent_tracks_attributes(@params)['perPage'].to_i).to eq 3
    end

    it "recent tracks from specific date" do
      from = Time.parse("2016-09-24 00:00:00 UTC")
      to = Time.parse("2016-09-25 00:00:00 UTC")
      @params[:from], @params[:to] = from, to
      check_date = from.strftime("%d %b %Y")
      actual_dates = @client.recent_tracks(@params).map { |e| e['date']['uts'].to_i }
      actual_dates.each do |actual_timestamp|
        expect((Time.at(actual_timestamp).utc).strftime("%d %b %Y")).to eq check_date
      end
    end

    context "global attributes" do
      expected_attributes = [ 'user', 'page', 'perPage', 'totalPages', 'total']

      it "attribute names" do
        expect(actual_attributes.keys).to match_array expected_attributes
      end

      expected_attributes.map do |attribute|
        it "##{attribute}'s value not nil" do
          expect(@client.recent_tracks_attributes(@params)[attribute]).not_to be_nil
        end
      end
    end

    context "tracks' attributes" do
      before(:all) do
        @recent_track = @client.recent_tracks(limit: 1).first
      end

      ['artist', 'name', 'streamable', 'mbid', 'album', 'url', 'image'].each do |attribute|
        it "##{attribute}" do
          expect(@recent_track).to include attribute
        end
      end
    end

  end

  describe ".track_info" do
    before(:all) do
      @artist = 'Cher'
      @track_name = 'Believe'
      @track = @client.track_info(@artist, @track_name)
    end

    expected_attributes = [ 'name', 'mbid', 'url', 'duration', 'streamable', 'listeners',
      'playcount', 'artist', 'album', 'userloved', 'toptags', 'wiki']

    expected_attributes.each do |attribute|
      it "##{attribute}" do
        expect(@track).to include attribute
      end
    end

    context "when not found" do
      let(:not_existing) { "NotExisting" }

      it "not existing artist" do
        track = @client.track_info(not_existing, @track_name)
        expect(track).to be_nil
      end

      it "not existing track name" do
        track = @client.track_info(@artist, not_existing)
        expect(track).to be_nil
      end

      it "not existing track name and artist" do
        track = @client.track_info(not_existing, not_existing)
        expect(track).to be_nil
      end
    end
  end
end
