# frozen_string_literal: true

require 'spec_helper'

describe UserFileContent do
  subject(:user_file_content) do
    build(:user_file_content)
  end

  describe 'validations' do
    it do
      expect(user_file_content).to validate_presence_of(:user_file)
    end

    it do
      expect(user_file_content).to validate_presence_of(:content)
    end

    it do
      expect(user_file_content).to validate_length_of(:content)
        .is_at_most(described_class::BLOB_LIMIT)
    end
  end
end
