# frozen_string_literal: true

require 'spec_helper'

describe Folder::DecoratorWithBreadcrumbs do
  subject(:decorator) { described_class.new(object) }

  let(:object) { folder }
  let!(:folder)  { create(:folder) }

  describe '#as_json' do
    let(:expected_json) do
      {
        id: folder.id,
        name: folder.name,
        breadcrumbs: []

      }.stringify_keys
    end

    it 'returns meta data defined json' do
      expect(decorator.as_json).to eq(expected_json)
    end

    context 'when object is an collecton' do
      let(:object) { Folder.all }

      let(:expected_json) do
        [
          {
            id: folder.id,
            name: folder.name,
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
          breadcrumbs: []
        }.deep_stringify_keys
      end

      it 'include errors' do
        expect(decorator.as_json).to eq(expected_json)
      end
    end
  end
end
