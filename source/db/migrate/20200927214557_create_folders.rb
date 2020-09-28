# frozen_string_literal: true

class CreateFolders < ActiveRecord::Migration[5.2]
  def change
    create_table :folders do |t|
      t.bigint :user_id, null: false, index: true
      t.string :name, null: false, limit: 255
      t.bigint :folder_id, index: true
    end

    add_foreign_key :folders, :users
    add_foreign_key :folders, :folders
  end
end
