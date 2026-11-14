class CreateViewingPositions < ActiveRecord::Migration[7.1]
  def change
    create_table :viewing_positions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :archive, null: false, foreign_key: true
      t.integer :current_position_seconds, default: 0, null: false

      t.timestamps
    end

    add_index :viewing_positions, [:user_id, :archive_id], unique: true
  end
end
