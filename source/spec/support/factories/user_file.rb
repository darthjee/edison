# frozen_string_literal: true

FactoryBot.define do
  factory :user_file, class: 'UserFile' do
    user
    sequence(:name) { |n| "file-#{n}.dat" }
    extension       { 'dat' }
    category        { 'misc' }
    md5             { Digest::MD5.hexdigest(Random.rand(100).to_s) }
    size            { Random.rand(10..100) }

    trait :deleted do
      deleted_at { 1.days.ago }
    end

    trait :uploaded do
      uploaded_at { Time.now }
    end

    trait :not_uploaded do
      uploaded_at { nil }
    end
  end
end
