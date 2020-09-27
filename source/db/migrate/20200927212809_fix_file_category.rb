# frozen_string_literal: true

class FixFileCategory < ActiveRecord::Migration[5.2]
  def up
    change_column :user_files, :category, :string, null: false, limit: 30
  end

  def down
    change_column :user_files, :category, :string, null: true, limit: 20
  end
end
