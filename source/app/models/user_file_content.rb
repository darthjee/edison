# frozen_string_literal: true

class UserFileContent < ApplicationRecord
  BLOB_LIMIT = (1024 * 64 - 1)

  belongs_to :user_file

  validates :user_file, presence: true
  validates :content,
            presence: true,
            length: { maximum: BLOB_LIMIT }
end
