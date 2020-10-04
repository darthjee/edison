# frozen_string_literal: true

class AddUploadedAtToUserFiles < ActiveRecord::Migration[5.2]
  def change
    add_column :user_files, :uploaded_at, :datetime
  end
end
