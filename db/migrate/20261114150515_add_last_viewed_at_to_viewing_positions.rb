class AddLastViewedAtToViewingPositions < ActiveRecord::Migration[7.1]
  def change
    add_column :viewing_positions, :last_viewed_at, :datetime
  end
end
