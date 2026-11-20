class Archive < ApplicationRecord
  belongs_to :user

  enum status: { scheduled: 0, live: 1, ended: 2 }

  has_many :viewing_positions, dependent: :destroy

  validates :title, presence: true
  validates :video_url, presence: true
  validates :duration_seconds, numericality: { greater_than_or_equal_to: 0 }

  def duration_formatted
    hours = duration_seconds / 3600
    minutes = (duration_seconds % 3600) / 60
    seconds = duration_seconds % 60

    if hours > 0
      format("%d時間%02d分%02d秒", hours, minutes, seconds)
    else
      format("%d分%02d秒", minutes, seconds)
    end
  end

  def thumbnail_url
    video_id = youtube_video_id
    return nil if video_id.blank?

    "https://img.youtube.com/vi/#{video_id}/hqdefault.jpg"
  end

  def youtube_video_id
    uri = URI.parse(video_url)
    if uri.host&.include?("youtu.be")
      uri.path.delete_prefix("/")
    elsif uri.path&.include?("/live/")
      uri.path.split("/").last
    else
      Rack::Utils.parse_query(uri.query)["v"]
    end
  rescue URI::InvalidURIError
    nil
  end

  def formatted_started_at
    started_at.strftime("%Y年%m月%d日 %H:%M")
  end
end
