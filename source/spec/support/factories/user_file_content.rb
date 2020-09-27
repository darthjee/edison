# frozen_string_literal: true

FactoryBot.define do
  factory :user_file_content, class: 'UserFileContent' do
    user_file
    sequence(:content) { |n| "content-#{n}" }
  end
end
