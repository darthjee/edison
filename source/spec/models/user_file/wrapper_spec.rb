# frozen_string_literal: true

require 'spec_helper'

describe UserFile::Wrapper do
  subject(:wrapper) { described_class.new(file_path) }

  let(:file_path) { "/tmp/#{file_name}" }
  let(:extension) { %w[text txt].sample }
  let(:file_name) do
    "#{Time.now.to_i}-#{Random.rand(100)}.#{extension}"
  end

  let(:file_size) { Random.rand(40..200) }

  let(:file_content) do
    file_size.times.map { ('a'..'z').to_a.sample }.join('')
  end

  before do
    File.open(file_path, 'w') do |f|
      f.write(file_content)
    end
  end

  after do
    File.delete(file_path)
  end

  describe '#name' do
    it 'returns file name' do
      expect(wrapper.name).to eq(file_name)
    end
  end

  describe '#extension' do
    it 'returns file extension' do
      expect(wrapper.extension).to eq(extension)
    end

    context 'when filename has no extension' do
      let(:file_name) do
        "#{Time.now.to_i}-#{Random.rand(100)}"
      end

      it 'returns no extension' do
        expect(wrapper.extension).to be_empty
      end
    end

    context 'when filename has double extension' do
      let(:file_name) do
        "#{Time.now.to_i}-#{Random.rand(100)}.csv.#{extension}"
      end

      it 'returns last extension' do
        expect(wrapper.extension).to eq(extension)
      end
    end

    context 'when extension is upcased' do
      let(:extension) { 'JPEG' }

      it 'returns lowercase' do
        expect(wrapper.extension).to eq('jpeg')
      end
    end
  end

  describe '#category' do
    it 'returns category' do
      expect(wrapper.category).to eq('text')
    end

    context 'when file is na image' do
      let(:extension) { 'jpeg' }

      it 'saves category' do
        expect(wrapper.category).to eq('image')
      end
    end
  end

  describe '#md5sum' do
    it 'returns file md5' do
      expect(wrapper.md5sum)
        .to eq(Digest::MD5.hexdigest(file_content))
    end
  end

  describe '#size' do
    it 'returns file size' do
      expect(wrapper.size)
        .to eq(file_size)
    end
  end
end
