# frozen_string_literal: true

require 'spec_helper'

describe Folder::DecoratorWithBreadcrumbs do
  subject(:decorator) { described_class.new(object) }

  let(:object)  { folder }
  let(:user)    { create(:user) }
  let(:parent)  { nil }
  let!(:folder) do
    create(:folder, user: user, folder: parent)
  end

  describe '#as_json' do
    let(:expected_json) do
      {
        id: folder.id,
        name: folder.name,
        parent_id: folder.folder_id,
        breadcrumbs: []

      }.stringify_keys
    end

    it 'returns meta data defined json' do
      expect(decorator.as_json).to eq(expected_json)
    end

    context 'when there is breadcrumb' do
      let(:root) { create(:folder, user: user) }

      let(:parent) do
        create(:folder, user: user, folder: root)
      end

      let(:decorated_root) do
        Folder::Decorator.new(root).as_json
      end

      let(:decorated_parent) do
        Folder::Decorator.new(parent).as_json
      end

      let(:expected_json) do
        {
          id: folder.id,
          name: folder.name,
          parent_id: folder.folder_id,
          breadcrumbs: [decorated_root, decorated_parent]

        }.stringify_keys
      end

      before do
        create(:folder, user: user)
      end

      it 'returns breadcrumbs' do
        expect(decorator.as_json).to eq(expected_json)
      end
    end

    context 'when object is an collecton' do
      let(:object) { Folder.all }

      let(:expected_json) do
        [
          {
            id: folder.id,
            name: folder.name,
            parent_id: folder.folder_id,
            breadcrumbs: []
          }
        ].map(&:stringify_keys)
      end

      it 'returns meta data defined json' do
        expect(decorator.as_json).to eq(expected_json)
      end
    end

    context 'when folder is invalid and has been validated' do
      let!(:folder) { build(:folder, name: nil) }

      let(:expected_json) do
        {
          id: folder.id,
          name: folder.name,
          breadcrumbs: [],
          parent_id: folder.folder_id,
          errors: {
            name: ["can't be blank"]
          }
        }.deep_stringify_keys
      end

      before { folder.valid? }

      it 'include errors' do
        expect(decorator.as_json).to eq(expected_json)
      end
    end

    context 'when folder is invalid and has not been validated' do
      let!(:folder) { build(:folder, name: nil) }

      let(:expected_json) do
        {
          id: folder.id,
          name: folder.name,
          parent_id: folder.folder_id,
          breadcrumbs: []
        }.deep_stringify_keys
      end

      it 'include errors' do
        expect(decorator.as_json).to eq(expected_json)
      end
    end
  end
end
