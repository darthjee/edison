# frozen_string_literal: true

require 'spec_helper'

describe Folder do
  subject(:folder) { build(:folder) }

  describe 'validations' do
    it do
      expect(folder).to be_valid
    end

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

  describe 'delete_all' do
    let(:folder)       { create(:folder) }
    let(:inner_folder) { create(:folder, folder: folder) }
    let(:user_file)    { create(:user_file, folder: inner_folder) }

    before do
      create(:user_file_content, user_file: user_file)
    end

    it do
      expect { described_class.delete_all }
        .to change(UserFileContent, :count)
        .by(-1)
    end

    it do
      expect { described_class.delete_all }
        .to change(UserFile, :count)
        .by(-1)
    end

    it do
      expect { described_class.delete_all }
        .to change(described_class, :count)
        .by(-2)
    end
  end
end
