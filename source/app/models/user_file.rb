# frozen_string_literal: true

class UserFile < ApplicationRecord
  MAX_FILE_SIZE = 1024 * 1024 * 1024 * 4

  belongs_to :user
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

  def self.from_file!(file)
    FileParser.process(self, file)
  end
end
