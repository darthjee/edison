# frozen_string_literal: true

class CreateUserFileContents < ActiveRecord::Migration[5.2]
  def change
    create_table :user_file_contents do |t|
      t.bigint :user_file_id, null: false, index: true
      t.blob   :content,      null: false, limit: (1024 * 64 - 1)
    end

    add_foreign_key :user_file_contents, :user_files
  end
end
