# frozen_string_literal: true

FactoryBot.define do
  factory :file, class: 'UserFile' do
    user
  end
end
