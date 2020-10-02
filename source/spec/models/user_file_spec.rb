# frozen_string_literal: true

require 'spec_helper'

describe UserFile do
  subject(:user_file) { build(:user_file) }

  describe '.from_file!' do
    let(:user)      { create(:user) }
    let(:file)      { File.open(file_path) }
    let(:folder)    { create(:folder, user: user) }
    let(:chunks)    { Random.rand(4..10) }
    let(:blob_size) { Random.rand(10..20) }
    let(:file_path) { "/tmp/#{file_name}" }
    let(:extension) { %w[text txt].sample }
    let(:file_name) do
      "#{Time.now.to_i}-#{Random.rand(100)}.#{extension}"
    end

    let(:from_file) do
      user.user_files.from_file!(file, folder)
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

    it { expect(from_file).to be_a(described_class) }

    it { expect(from_file).to be_valid }

    it { expect(from_file).to be_persisted }

    it 'saves file name' do
      expect(from_file.name).to eq(file_name)
    end

    it 'saves file extension' do
      expect(from_file.extension).to eq(extension)
    end

    it 'saves category' do
      expect(from_file.category).to eq('text')
    end

    it 'saves file md5' do
      expect(from_file.md5)
        .to eq(Digest::MD5.hexdigest(file_content))
    end

    it 'saves file size' do
      expect(from_file.size)
        .to eq(file_size)
    end

    it do
      expect { from_file }
        .to change(described_class, :count)
        .by(1)
    end

    it do
      expect { from_file }
        .to change(UserFileContent, :count)
        .by(chunks)
    end

    context 'when content creation is done' do
      let(:blob_size) { UserFileContent::BLOB_LIMIT }

      it 'saves content' do
        expect(from_file.user_file_contents.pluck(:content).join(''))
          .to eq(file_content)
      end
    end

    context 'when filename has no extension' do
      let(:file_name) do
        "#{Time.now.to_i}-#{Random.rand(100)}"
      end

      it 'saves empty extension' do
        expect(from_file.extension).to be_empty
      end
    end

    context 'when filename has double extension' do
      let(:file_name) do
        "#{Time.now.to_i}-#{Random.rand(100)}.csv.#{extension}"
      end

      it 'saves last extension' do
        expect(from_file.extension).to eq(extension)
      end
    end

    context 'when file is na image' do
      let(:extension) { 'jpeg' }

      it 'saves category' do
        expect(from_file.category).to eq('image')
      end
    end
  end

  describe '#read' do
    let(:user_file)    { create(:user_file) }
    let(:chunks)       { %w[this are chunks of file] }
    let(:file_path)    { "/tmp/#{file_name}" }
    let(:file)         { File.open(file_path, 'wb') }
    let(:reading_file) { File.open(file_path, 'rb') }
    let(:file_name) do
      "#{Time.now.to_i}-#{Random.rand(10_000)}.txt"
    end

    before do
      chunks.each do |chunk|
        create(:user_file_content, user_file: user_file, content: chunk)
      end

      user_file.read do |chunk|
        file.write(chunk)
      end

      file.close
    end

    after do
      reading_file.close

      File.delete(file_path)
    end

    it do
      expect(reading_file.read).to eq(chunks.join(''))
    end

    context 'when there are no chunks' do
      let(:chunks) { [] }

      it do
        expect(reading_file.read).to be_empty
      end
    end
  end

  describe 'validations' do
    it do
      expect(user_file).to be_valid
    end

    it do
      expect(user_file).to validate_presence_of(:user)
    end

    it do
      expect(user_file).to validate_presence_of(:name)
    end

    it do
      expect(user_file).to validate_length_of(:name)
        .is_at_most(255)
    end

    it do
      expect(user_file).not_to validate_presence_of(:extension)
    end

    it do
      expect(user_file).to validate_length_of(:extension)
        .is_at_most(10)
    end

    it do
      expect(user_file).to validate_presence_of(:category)
    end

    it do
      expect(user_file).to validate_length_of(:category)
        .is_at_most(30)
    end

    it do
      expect(user_file).to validate_presence_of(:md5)
    end

    it do
      expect(user_file).to validate_length_of(:md5)
        .is_at_most(32)
    end

    it do
      expect(user_file).to validate_presence_of(:size)
    end

    it do
      expect(user_file).to validate_numericality_of(:size)
        .is_greater_than_or_equal_to(0)
    end

    it do
      expect(user_file).to validate_numericality_of(:size)
        .is_less_than(described_class::MAX_FILE_SIZE)
    end

    it do
      expect(user_file).to validate_numericality_of(:size)
        .only_integer
    end

    it do
      expect(user_file).not_to validate_presence_of(:folder)
    end
  end
end
