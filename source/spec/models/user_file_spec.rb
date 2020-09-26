# frozen_string_literal: true

require 'spec_helper'

describe UserFile do
  subject(:user_file) do
    build(:file)
  end

  describe 'validations' do
    it do
      expect(user_file).to validate_presence_of(:user)
    end

    it do
      expect(user_file).to validate_presence_of(:name)
    end

    it do
      expect(user_file).to validate_length_of(:name)
        .is_at_most(255)
    end

    it do
      expect(user_file).to validate_presence_of(:extension)
    end

    it do
      expect(user_file).to validate_length_of(:extension)
        .is_at_most(10)
    end

    it do
      expect(user_file).not_to validate_presence_of(:type)
    end

    it do
      expect(user_file).to validate_length_of(:type)
        .is_at_most(10)
    end

    it do
      expect(user_file).not_to validate_presence_of(:category)
    end

    it do
      expect(user_file).to validate_length_of(:category)
        .is_at_most(20)
    end

    it do
      expect(user_file).to validate_presence_of(:md5)
    end

    it do
      expect(user_file).to validate_length_of(:md5)
        .is_at_most(32)
    end
  end
end
