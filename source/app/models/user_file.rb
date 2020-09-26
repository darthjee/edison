# frozen_string_literal: true

class UserFile < ApplicationRecord
  belongs_to :user

  validates :user, presence: true

  validates :name,
            presence: true,
            length: { maximum: 255 }

  validates :extension,
            presence: true,
            length: { maximum: 10 }

  validates :type,
            length: { maximum: 10 }

  validates :category,
            length: { maximum: 20 }

  validates :md5,
            presence: true,
            length: { maximum: 32 }
end
