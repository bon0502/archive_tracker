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

    format("%02d:%02d:%02d", hours, minutes, seconds)
  end

  def thumbnail_url
    video_id = extract_youtube_id
    return nil if video_id.blank?

    "https://img.youtube.com/vi/#{video_id}/hqdefault.jpg"
  end

  private

  def extract_youtube_id
    if video_url =~ /youtube\.com\/watch\?v=([^&]+)/
      return $1
    end

    if video_url =~ /youtu\.be\/([^?&]+)/
      return $1
    end

    nil
  end
end
