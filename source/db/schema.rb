# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_10_04_165752) do

  create_table "folders", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.bigint "folder_id"
    t.datetime "deleted_at"
    t.index ["folder_id"], name: "index_folders_on_folder_id"
    t.index ["user_id"], name: "index_folders_on_user_id"
  end

  create_table "sessions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "expiration"
    t.index ["user_id"], name: "fk_rails_758836b4f0"
  end

  create_table "user_file_contents", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_file_id", null: false
    t.binary "content", null: false
    t.index ["user_file_id"], name: "index_user_file_contents_on_user_file_id"
  end

  create_table "user_files", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.string "extension", limit: 10, null: false
    t.string "category", limit: 30, null: false
    t.string "md5", limit: 32, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "folder_id"
    t.integer "size", null: false, unsigned: true
    t.datetime "deleted_at"
    t.datetime "uploaded_at"
    t.index ["category"], name: "index_user_files_on_category"
    t.index ["folder_id"], name: "fk_rails_23582aaaee"
    t.index ["user_id"], name: "index_user_files_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "login", null: false
    t.string "email", null: false
    t.string "encrypted_password", null: false
    t.string "salt", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["login"], name: "index_users_on_login", unique: true
  end

  add_foreign_key "folders", "folders"
  add_foreign_key "folders", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "user_file_contents", "user_files"
  add_foreign_key "user_files", "folders"
  add_foreign_key "user_files", "users"
end
