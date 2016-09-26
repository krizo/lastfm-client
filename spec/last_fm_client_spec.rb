require "spec_helper"

describe "LastfmClient" do
  before(:all) do
    @client = LastfmClient.new(ENV['API_KEY'], 'kriz_z')
  end

  describe ".resent_tracks" do
    before(:each) do
      @params = { ignore_now_playing: true }
    end

    it "returns recent 50 tracks by default" do
      expect(@client.recent_tracks(@params).count).to eq 50
    end

    it "returns recent with limit 3" do
      @params[:limit] = 3
      expect(@client.recent_tracks(@params).count).to eq 3
    end
  end
end
