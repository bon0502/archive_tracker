require "net/http"
require "json"

class YoutubeVideoFetcher
  API_URL = "https://www.googleapis.com/youtube/v3/videos"

  def initialize(video_id)
    @video_id = video_id
  end

  def fetch
    uri = URI(API_URL)
    uri.query = URI.encode_www_form(
      id: @video_id,
      part: "snippet,contentDetails,liveStreamingDetails",
      key: ENV["YOUTUBE_API_KEY"]
    )

    response = Net::HTTP.get(uri)
    data = JSON.parse(response)
    item = data["items"]&.first
    return nil unless item

    {
      title: item.dig("snippet", "title"),
      streamer_name: item.dig("snippet", "channelTitle"),
      duration_seconds: parse_duration(item.dig("contentDetails", "duration")),
      started_at: item.dig("liveStreamingDetails", "actualStartTime") || item.dig("snippet", "publishedAt")
    }
  end

  private

  def parse_duration(iso8601_duration)
    return nil if iso8601_duration.blank?
    ActiveSupport::Duration.parse(iso8601_duration).to_i
  end
end
