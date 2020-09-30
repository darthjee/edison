# frozen_string_literal: true

class AddDeletedAtToFolders < ActiveRecord::Migration[5.2]
  def change
    change_table :folders do |t|
      t.datetime :deleted_at
    end
  end
end
