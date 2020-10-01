# frozen_string_literal: true

require 'spec_helper'

describe FoldersController, :logged do
  describe 'GET show' do
    let(:parameters) { { format: :json, id: folder_id } }

    let(:expected_response) { Folder::Decorator.new(folder).to_json }
    let!(:folder)           { create(:folder, user: logged_user) }
    let(:folder_id)         { folder.id }

    before do
      get :show, params: parameters
    end

    context 'when folder is not specified' do
      let(:expected_response) { Folder::Decorator.new(folder).to_json }
      let(:folder)            { Folder.new }
      let(:folder_id)         { 0 }

      context 'when user is not logged', :not_logged do
        it do
          expect(response).not_to be_successful
        end

        it do
          expect(response.status).to eq(404)
        end

        it 'returns empty' do
          expect(response.body).to be_empty
        end
      end

      context 'when user is logged' do
        it do
          expect(response).to be_successful
        end

        it 'returns empty folder' do
          expect(response.body).to eq(expected_response)
        end
      end
    end

    context 'when folder is specified' do
      context 'when user is not logged', :not_logged do
        it do
          expect(response).not_to be_successful
        end

        it do
          expect(response.status).to eq(404)
        end

        it 'returns empty' do
          expect(response.body).to be_empty
        end
      end

      context 'when user is logged' do
        it do
          expect(response).to be_successful
        end

        it 'returns user inner folders' do
          expect(response.body).to eq(expected_response)
        end
      end
    end

    context "when another user's folder is specified" do
      let(:folder_id) { folder.id }
      let(:folder)    { create(:folder) }

      it do
        expect(response).not_to be_successful
      end

      it do
        expect(response.status).to eq(404)
      end

      it 'returns empty' do
        expect(response.body).to be_empty
      end
    end

    context 'when folder has been deleted' do
      let(:folder) do
        create(:folder, user: logged_user, deleted_at: 1.day.ago)
      end

      let(:folder_id) { folder.id }

      it do
        expect(response).not_to be_successful
      end

      it do
        expect(response.status).to eq(404)
      end

      it 'returns empty' do
        expect(response.body).to be_empty
      end
    end
  end

  describe 'GET index' do
    let(:parameters) { { format: :json, folder_id: folder_id } }

    let(:expected_response) { Folder::Decorator.new(root_folders).to_json }
    let!(:root_folders)     { create_list(:folder, 3, user: logged_user) }
    let(:first_folder)      { root_folders.first }
    let(:folder_id)         { 0 }
    let(:deletion_time)     { nil }

    let!(:inner_folder) do
      create(:folder, user: logged_user, folder: first_folder)
    end

    before do
      first_folder.update(deleted_at: deletion_time)
      create(:folder, user: logged_user, deleted_at: 1.day.ago)

      get :index, params: parameters
    end

    context 'when folder is not specified' do
      context 'when user is not logged', :not_logged do
        it do
          expect(response).not_to be_successful
        end

        it do
          expect(response.status).to eq(404)
        end

        it 'returns empty' do
          expect(response.body).to be_empty
        end
      end

      context 'when user is logged' do
        it do
          expect(response).to be_successful
        end

        it 'returns user root folders' do
          expect(response.body).to eq(expected_response)
        end
      end
    end

    context 'when folder is specified' do
      let(:folder_id) { first_folder.id }

      let(:expected_response) do
        Folder::Decorator.new([inner_folder]).to_json
      end

      context 'when user is not logged', :not_logged do
        it do
          expect(response).not_to be_successful
        end

        it do
          expect(response.status).to eq(404)
        end

        it 'returns empty' do
          expect(response.body).to be_empty
        end
      end

      context 'when user is logged' do
        it do
          expect(response).to be_successful
        end

        it 'returns user inner folders' do
          expect(response.body).to eq(expected_response)
        end
      end
    end

    context "when another user's folder is specified" do
      let(:folder_id) { folder.id }
      let(:folder)    { create(:folder) }

      it do
        expect(response).not_to be_successful
      end

      it do
        expect(response.status).to eq(404)
      end

      it 'returns empty' do
        expect(response.body).to be_empty
      end
    end

    context 'when parent_folder has been deleted' do
      let(:folder_id)     { first_folder.id }
      let(:deletion_time) { 1.day.ago }

      it do
        expect(response).not_to be_successful
      end

      it do
        expect(response.status).to eq(404)
      end

      it 'returns empty' do
        expect(response.body).to be_empty
      end
    end
  end
end
