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

ActiveRecord::Schema.define(version: 5) do

  create_table "accounts", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "email"
    t.string "crypted_password"
    t.string "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "songs", force: :cascade do |t|
    t.string "title"
    t.integer "tempo"
    t.integer "account_id"
    t.boolean "public"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tracks", force: :cascade do |t|
    t.string "name"
    t.integer "track_number"
    t.integer "song_id"
    t.text "score"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "program"
  end

end
