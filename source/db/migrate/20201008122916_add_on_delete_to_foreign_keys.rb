# frozen_string_literal: true

class AddOnDeleteToForeignKeys < ActiveRecord::Migration[5.2]
  def up
    change_foreign_key :folders, :folders, on_delete: :cascade
    change_foreign_key :folders, :users, on_delete: :cascade
    change_foreign_key :sessions, :users, on_delete: :cascade
    change_foreign_key :user_file_contents, :user_files, on_delete: :cascade
    change_foreign_key :user_files, :folders, on_delete: :cascade
    change_foreign_key :user_files, :users, on_delete: :cascade
  end

  def down
    change_foreign_key :folders, :folders
    change_foreign_key :folders, :users
    change_foreign_key :sessions, :users
    change_foreign_key :user_file_contents, :user_files
    change_foreign_key :user_files, :folders
    change_foreign_key :user_files, :users
  end

  def change_foreign_key(child, parent, **options)
    remove_foreign_key child, parent
    add_foreign_key child, parent, **options
  end
end
