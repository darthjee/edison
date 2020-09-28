# frozen_string_literal: true

require 'spec_helper'

describe Folder do
  subject(:folder) { build(:folder) }

  describe 'validations' do
    it do
      expect(folder).to validate_presence_of(:user)
    end

    it do
      expect(folder).to validate_presence_of(:name)
    end

    it do
      expect(folder).to validate_length_of(:name)
        .is_at_most(255)
    end

    it do
      expect(folder).not_to validate_presence_of(:folder)
    end
  end
end
