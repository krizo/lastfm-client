require 'spec_helper'
require 'last_fm_client'
require 'exporter'
require 'active_support/core_ext'

describe 'Exporter' do
  let(:csv_file) { "#{last_fm_client.user}.csv" }
  let(:last_fm_client) { LastfmClient.new(ENV['API_KEY'], 'kriz_z') }
  let(:exporter) { CsvExporter.new(last_fm_client, csv_file) }
  let(:expected_tracks_count) { 20 }

  describe ".export_recent_tracks" do
    let(:request_params) do
      {
        start_page: 3,
        end_page: 4,
        ignore_now_playing: true,
        limit: 10
      }
    end

    it "has valid records count" do
      exporter.export_recent_tracks(csv_file, request_params)
      expect(exporter.exported_records).to eq (expected_tracks_count)
    end
  end

  describe 'export_for_timeframe' do
    let(:start_time) { Time.parse("2013-05-03 21:00:00 UTC") }
    let(:end_time) { Time.parse("2013-05-06 08:30:00 UTC") }
    let(:request_params) do
      {
        from: start_time,
        to: end_time,
        ignore_now_playing: true
      }
    end
    let(:expected_tracks_count) {
      last_fm_client.recent_tracks_attributes(request_params)['total'].to_i
    }

    it "has valid records count" do
      exporter.export_for_timeframe(csv_file, start_time, end_time, { limit: 10 })
      expect(exporter.exported_records).to eq (expected_tracks_count)
    end
  end
end
