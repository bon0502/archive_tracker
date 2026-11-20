class AddStartedAtToArchives < ActiveRecord::Migration[7.1]
  def change
    add_column :archives, :started_at, :datetime
  end
end
