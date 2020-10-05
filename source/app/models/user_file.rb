# frozen_string_literal: true

class UserFile < ApplicationRecord
  MAX_FILE_SIZE = 1024 * 1024 * 1024 * 4

  belongs_to :user
  belongs_to :folder, required: false
  has_many   :user_file_contents

  validates :user, presence: true

  validates :name,
            presence: true,
            length: { maximum: 255 }

  validates :extension,
            length: { maximum: 10 }

  validates :category,
            presence: true,
            length: { maximum: 30 }

  validates :md5,
            presence: true,
            length: { maximum: 32 }

  validates :size,
            presence: true,
            numericality: {
              less_than: MAX_FILE_SIZE,
              greater_than_or_equal_to: 0,
              only_integer: true
            }

  scope :not_deleted,  -> { where(deleted_at: nil) }
  scope :not_uploaded, -> { where(uploaded_at: nil) }

  def self.from_file!(file_path, folder)
    FileParser.process(self, file_path, folder)
  end

  def undelete
    update(deleted_at: nil)
  end

  def read
    user_file_contents.find_each do |chunk|
      yield chunk.content
    end
  end

  def content_valid?
    user_file_contents.sum('char_length(content)') == size
  end

  def uploaded?
    uploaded_at.present?
  end

  def deleted?
    deleted_at.present?
  end

  def mark_uploaded
    update(
      deleted_at: nil,
      uploaded_at: Time.now
    )
  end
end
