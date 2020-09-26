# frozen_string_literal: true

class CreateUserFile < ActiveRecord::Migration[5.2]
  def change
    create_table :user_files do |t|
      t.bigint :user_id,   null: false, index: true
      t.string :name,      null: false, limit: 255
      t.string :extension, null: false, limit: 10
      t.string :type,                   limit: 10
      t.string :category,               limit: 20, index: true
      t.string :md5, null: false, limit: 32

      t.timestamps
    end

    add_foreign_key :user_files, :users
  end
end
