require 'spec_helper'
require 'last_fm_client'
require 'exporter'

describe 'Exporter' do
  let(:csv_file) { "#{last_fm_client.user}.csv" }
  let(:last_fm_client) { LastfmClient.new(ENV['API_KEY'], 'kriz_z') }
  let(:exporter) { CsvExporter.new(last_fm_client, csv_file) }

  describe ".export_recent_tracks" do
    let(:expected_tracks) { last_fm_client.recent_tracks(page: 3, ignore_now_playing: true) }
    
    it "has valid records count" do
      exporter.export_recent_tracks(csv_file, { start_page: 3, end_page: 3 })
      expect(exporter.exported_records).to eq (expected_tracks.count - 1)
    end
  end
end
