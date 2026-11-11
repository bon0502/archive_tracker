class CreateArchives < ActiveRecord::Migration[7.1]
  def change
    create_table :archives do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.string :streamer_name
      t.string :video_url, null: false
      t.string :video_id
      t.integer :duration_seconds, null: false, default: 0
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
