# frozen_string_literal: true

require 'spec_helper'

describe UserFilesController, :logged do
  describe 'GET show' do
    let(:parameters) do
      { format: :json, folder_id: folder_id, id: user_file.id }
    end

    let(:expected_response) { UserFile::Decorator.new(user_file).to_json }
    let(:user_file)         { create(:user_file, user: logged_user) }
    let(:folder)            { create(:folder, user: logged_user) }
    let(:folder_id)         { 0 }

    before do
      get :show, params: parameters
    end

    context 'when folder is not specified and file is not in a folder' do
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

    context 'when folder is not specified and file is in a folder' do
      let(:user_file) { create(:user_file, user: logged_user, folder: folder) }

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

    context 'when folder is specified and file is in the folder' do
      let(:folder_id) { folder.id }
      let(:user_file) { create(:user_file, user: logged_user, folder: folder) }

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
      let(:folder_id) { folder.id }

      let(:folder) do
        create(:folder, user: logged_user, deleted_at: 1.day.ago)
      end

      let(:user_file) do
        create(:user_file, user: logged_user, folder: folder)
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

    context 'when file has been deleted' do
      let(:folder_id) { folder.id }

      let(:user_file) do
        create(
          :user_file, user: logged_user,
                      folder: folder,
                      deleted_at: 1.day.ago
        )
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

  describe 'GET index' do
    let(:parameters) { { format: :json, folder_id: folder_id } }

    let(:expected_response) { UserFile::Decorator.new(root_user_files).to_json }
    let!(:root_user_files)  { create_list(:user_file, 3, user: logged_user) }
    let(:base_folder)       { create(:folder, user: logged_user) }
    let(:folder_id)         { 0 }

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
      let(:folder_id) { base_folder.id }

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

    context 'when folder has been deleted' do
      let(:folder_id) { folder.id }

      let(:folder) do
        create(:folder, user: logged_user, deleted_at: 1.day.ago)
      end

      let(:user_file) do
        create(:user_file, user: logged_user, folder: folder)
      end

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
  end

  describe 'GET download' do
    let(:user)      { logged_user }
    let(:extension) { '.pdf' }
    let(:folder)    { create(:folder, user: user) }
    let(:chunks)    { %w[these are the contents] }
    let(:folder_id) { folder.id }
    let(:size)      { chunks.join.size }

    let(:user_file) do
      create(
        :user_file,
        user: user,
        folder: folder,
        extension: 'pdf',
        size: size
      )
    end

    let(:parameters) do
      { format: :raw, folder_id: folder_id, id: user_file.id }
    end

    before do
      chunks.each do |chunk|
        create(:user_file_content, user_file: user_file, content: chunk)
      end

      get :download, params: parameters
    end

    it do
      expect(response).to be_successful
    end

    it do
      expect(response.status).to eq(200)
    end

    it do
      expect(response.body).to eq(chunks.join)
    end

    it 'sets content type header' do
      expect(response.headers['Content-Type'])
        .to eq('application/pdf')
    end

    it 'sets content size' do
      expect(response.headers['Content-Length'])
        .to eq(size)
    end

    it 'sets content etag' do
      expect(response.headers['ETag'])
        .to eq(user_file.md5)
    end

    it 'sets content disposition' do
      expect(response.headers['Content-Disposition'])
        .to eq("attachment; filename=\"#{user_file.name}\"")
    end

    context 'when file is in root folder' do
      let(:folder)    { nil }
      let(:folder_id) { 0 }

      it do
        expect(response).to be_successful
      end

      it do
        expect(response.status).to eq(200)
      end

      it do
        expect(response.body).to eq(chunks.join)
      end
    end

    context 'when requesting another folder' do
      let(:folder_id) { create(:folder, user: user).id }

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

    context 'when file belongs to another user' do
      let(:user) { create(:user) }

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

    context 'when requesting root folder' do
      let(:folder_id) { 0 }

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
  end
end
