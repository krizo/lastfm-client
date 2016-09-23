require "spec_helper"

describe "LastfmClient" do
  before(:all) do
    @client = LastfmClient.new(ENV['API_KEY'], 'kriz_z')
  end

  describe ".resent_tracks" do
    it "returns recent 51 tracks by default" do
      expect(@client.recent_tracks.count).to eq 51
    end
  end
end
