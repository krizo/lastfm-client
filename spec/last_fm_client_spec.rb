require "spec_helper"

describe "LastfmClient" do
  before(:all) do
    @client = LastfmClient.new(ENV['API_KEY'], 'kriz_z')
  end

  expected_attributes = [ 'user', 'page', 'perPage', 'totalPages', 'total']

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

    it "attribute names" do
      expect(actual_attributes.keys).to match_array expected_attributes
    end

    expected_attributes.map do |attribute|
      it "#{attribute}'s value not nil" do
        expect(@client.recent_tracks_attributes(@params)[attribute]).not_to be_nil
      end
    end
  end
end
