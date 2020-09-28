# frozen_string_literal: true

class Folder < ApplicationRecord
  belongs_to :user
  belongs_to :folder
  has_many :folders

  validates :user, presence: true

  validates :name,
            presence: true,
            length: { maximum: 255 }
end
