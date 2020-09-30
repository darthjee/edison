# frozen_string_literal: true

require 'spec_helper'

describe UserFilesController, :logged do
  describe 'GET index' do
    let(:parameters) { { format: :json } }

    let(:expected_response) { UserFile::Decorator.new(root_user_files).to_json }
    let!(:root_user_files)  { create_list(:user_file, 3, user: logged_user) }
    let(:base_folder)       { create(:folder, user: logged_user) }

    let!(:inner_file) do
      create(:user_file, user: logged_user, folder: base_folder)
    end

    before do
      create(:user_file, user: logged_user, deleted_at: 1.day.ago)

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

        it 'returns user root files' do
          expect(response.body).to eq(expected_response)
        end
      end
    end

    context 'when folder is specified' do
      let(:parameters) { { format: :json, folder_id: base_folder.id } }

      let(:expected_response) do
        UserFile::Decorator.new([inner_file]).to_json
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

        it 'returns user inner files' do
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
