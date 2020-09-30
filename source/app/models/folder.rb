# frozen_string_literal: true

class Folder < ApplicationRecord
  belongs_to :user
  belongs_to :folder, required: false
  has_many :folders
  has_many :user_files

  validates :user, presence: true

  validates :name,
            presence: true,
            length: { maximum: 255 }

  scope :root, -> { where(folder: nil) }
end
