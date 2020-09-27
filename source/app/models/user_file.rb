# frozen_string_literal: true

class UserFile < ApplicationRecord
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

  def self.from_file!(file)
    FileParser.process(self, file)
  end
end
