# frozen_string_literal: true

require 'spec_helper'

describe FoldersController, :logged do
  describe 'GET index' do
    let(:parameters) { { format: :json } }

    let(:expected_response) { Folder::Decorator.new(root_folders).to_json }
    let!(:root_folders)     { create_list(:folder, 3, user: logged_user) }
    let(:first_folder)      { root_folders.first }

    let!(:inner_folder) do
      create(:folder, user: logged_user, folder: first_folder)
    end

    before do
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
      let(:parameters) { { format: :json, folder_id: first_folder.id } }

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
      let(:parameters) { { format: :json, folder_id: folder.id } }
      let(:folder)     { create(:folder) }

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
