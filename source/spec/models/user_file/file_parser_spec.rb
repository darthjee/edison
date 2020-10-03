# frozen_string_literal: true

require 'spec_helper'

describe UserFile::FileParser do
  describe '.process' do
    let(:user)      { create(:user) }
    let(:chunks)    { Random.rand(4..10) }
    let(:blob_size) { Random.rand(10..20) }
    let(:file_path) { "/tmp/#{file_name}" }
    let(:extension) { %w[text txt].sample }
    let(:folder)    { user.folders.create(name: :folder) }
    let(:file_name) do
      "#{Time.now.to_i}-#{Random.rand(100)}.#{extension}"
    end

    let(:processed_file) do
      described_class.process(user.user_files, file_path, folder)
    end

    let(:file_size) do
      chunks * blob_size
    end

    let(:file_content) do
      file_size.times.map { ('a'..'z').to_a.sample }.join('')
    end

    before do
      allow(Settings).to receive(:file_chunk_size)
        .and_return(blob_size)

      File.open(file_path, 'w') do |f|
        f.write(file_content)
      end
    end

    after do
      File.delete(file_path)
    end

    it { expect(processed_file).to be_a(UserFile) }

    it { expect(processed_file).to be_valid }

    it { expect(processed_file).to be_persisted }

    it 'saves file name' do
      expect(processed_file.name).to eq(file_name)
    end

    it 'saves file extension' do
      expect(processed_file.extension).to eq(extension)
    end

    it 'saves category' do
      expect(processed_file.category).to eq('text')
    end

    it 'saves file md5' do
      expect(processed_file.md5)
        .to eq(Digest::MD5.hexdigest(file_content))
    end

    it 'saves file size' do
      expect(processed_file.size)
        .to eq(file_size)
    end

    it 'saves folder' do
      expect(processed_file.folder).to eq(folder)
    end

    it do
      expect { processed_file }
        .to change(UserFile, :count)
        .by(1)
    end

    it do
      expect { processed_file }
        .to change(UserFileContent, :count)
        .by(chunks)
    end

    context 'when content creation is done' do
      let(:blob_size) { UserFileContent::BLOB_LIMIT }

      it 'saves content' do
        expect(processed_file.user_file_contents.pluck(:content).join(''))
          .to eq(file_content)
      end
    end

    context 'when filename has no extension' do
      let(:file_name) do
        "#{Time.now.to_i}-#{Random.rand(100)}"
      end

      it 'saves empty extension' do
        expect(processed_file.extension).to be_empty
      end
    end

    context 'when filename has double extension' do
      let(:file_name) do
        "#{Time.now.to_i}-#{Random.rand(100)}.csv.#{extension}"
      end

      it 'saves last extension' do
        expect(processed_file.extension).to eq(extension)
      end
    end

    context 'when file is na image' do
      let(:extension) { 'jpeg' }

      it 'saves category' do
        expect(processed_file.category).to eq('image')
      end
    end

    context 'when same file already exists' do
      let(:previous_saved_entry) do
        described_class.process(user.user_files, file_path, folder)
      end

      before do
        previous_saved_entry
      end

      it { expect(processed_file).to eq(previous_saved_entry) }

      it do
        expect { processed_file }
          .not_to change(UserFile, :count)
      end

      it do
        expect { processed_file }
          .not_to change(UserFileContent, :count)
      end
    end

    context 'when same file had been deleted' do
      let(:previous_saved_entry) do
        described_class.process(user.user_files, file_path, folder)
      end

      before do
        previous_saved_entry.update(deleted_at: 1.hour.ago)
      end

      it { expect(processed_file).to eq(previous_saved_entry) }

      it do
        expect { processed_file }
          .not_to change(UserFile, :count)
      end

      it do
        expect { processed_file }
          .not_to change(UserFileContent, :count)
      end

      it do
        expect { processed_file }
          .to change { previous_saved_entry.reload.deleted_at }
          .to(nil)
      end
    end

    context 'when same file already exists in another folder' do
      let(:previous_saved_entry) do
        described_class.process(user.user_files, file_path, nil)
      end

      before do
        previous_saved_entry
      end

      it { expect(processed_file).not_to eq(previous_saved_entry) }

      it do
        expect { processed_file }.to change(UserFile, :count)
      end
    end

    context 'when same file already exists for other user' do
      let(:folder)        { nil }
      let(:other_user)    { create(:user) }

      let(:previous_saved_entry) do
        described_class.process(other_user.user_files, file_path, folder)
      end

      before do
        previous_saved_entry.update(deleted_at: 1.hour.ago)
      end

      it { expect(processed_file).not_to eq(previous_saved_entry) }

      it do
        expect { processed_file }.to change(UserFile, :count)
      end

      it do
        expect { processed_file }
          .not_to(change { previous_saved_entry.reload.deleted_at })
      end
    end

    context 'when same file already exists with another content' do
      let!(:previous_saved_entry) do
        create(
          :user_file,
          name: file_name,
          folder: folder,
          user: user
        )
      end

      it do
        expect(processed_file)
          .not_to eq(previous_saved_entry)
      end

      it do
        expect { processed_file }
          .to change(UserFile, :count)
      end

      it 'deletes old file' do
        expect { processed_file }
          .to change { previous_saved_entry.reload.deleted_at }
          .from(nil)
      end
    end
  end
end
