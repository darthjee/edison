# frozen_string_literal: true

class FixFileType < ActiveRecord::Migration[5.2]
  def change
    remove_column :user_files, :type
  end
end
