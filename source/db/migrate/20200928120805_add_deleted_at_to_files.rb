# frozen_string_literal: true

class AddDeletedAtToFiles < ActiveRecord::Migration[5.2]
  def change
    change_table :user_files do |t|
      t.datetime :deleted_at
    end
  end
end
