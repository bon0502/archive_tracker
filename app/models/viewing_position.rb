class ViewingPosition < ApplicationRecord
  belongs_to :user
  belongs_to :archive

  validates :user_id, uniqueness: { scope: :archive_id }
  validates :current_position_seconds,
            numericality: { greater_than_or_equal_to: 0 },
            allow_nil: true

  before_save :set_last_viewed_at

  validate :position_within_duration

  def remaining_seconds
    remaining = archive.duration_seconds - current_position_seconds
    remaining.positive? ? remaining : 0
  end

  def progress_percentage
    return 0 if archive.duration_seconds.zero?

    (current_position_seconds.to_f / archive.duration_seconds * 100).round(1)
  end

  private

  def max_position_seconds
    archive.duration_seconds.positive? ? archive.duration_seconds : Float::INFINITY
  end

  def position_within_duration
    return if current_position_seconds.blank?

    if current_position_seconds > max_position_seconds
      errors.add(:current_position_seconds, "は動画の長さを超えられません")
    end
  end

  def set_last_viewed_at
    self.last_viewed_at = Time.current if current_position_seconds_changed?
  end
end
