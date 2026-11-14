# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2026_11_12_120348) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "archives", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.string "streamer_name"
    t.string "video_url", null: false
    t.string "video_id"
    t.integer "duration_seconds", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_archives_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.string "nickname", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "viewing_positions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "archive_id", null: false
    t.integer "current_position_seconds", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["archive_id"], name: "index_viewing_positions_on_archive_id"
    t.index ["user_id", "archive_id"], name: "index_viewing_positions_on_user_id_and_archive_id", unique: true
    t.index ["user_id"], name: "index_viewing_positions_on_user_id"
  end

  add_foreign_key "archives", "users"
  add_foreign_key "viewing_positions", "archives"
  add_foreign_key "viewing_positions", "users"
end
