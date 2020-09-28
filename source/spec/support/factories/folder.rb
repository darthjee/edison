# frozen_string_literal: true

FactoryBot.define do
  factory :folder, class: 'Folder' do
    user
    sequence(:name) { |n| "folder-#{n}" }
  end
end
