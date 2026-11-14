class ViewingPosition < ApplicationRecord
  belongs_to :user
  belongs_to :archive

  validates :user_id, uniqueness: { scope: :archive_id }

  def remaining_seconds
    remaining = archive.duration_seconds - current_position_seconds
    remaining.positive? ? remaining : 0
  end

  def progress_percentage
    return 0 if archive.duration_seconds.zero?

    (current_position_seconds.to_f / archive.duration_seconds * 100).round(1)
  end
end
