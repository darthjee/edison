# frozen_string_literal: true

class AddFilesFields < ActiveRecord::Migration[5.2]
  def change
    change_table :user_files do |t|
      t.bigint :folder_id, index: true
      t.integer :size, null: false, unsigned: true
    end

    add_foreign_key :user_files, :folders
  end
end
