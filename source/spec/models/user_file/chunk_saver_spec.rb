# frozen_string_literal: true

require 'spec_helper'

describe UserFile::ChunkSaver do
  let(:user_file) { create(:user_file, size: file_size) }
  let(:file)      { UserFile::Wrapper.new(file_path) }
  let(:file_path) { "/tmp/#{file_name}" }
  let(:extension) { %w[text txt dat].sample }
  let(:file_name) do
    "#{Time.now.to_i}-#{Random.rand(100)}.#{extension}"
  end

  let(:chunk_size) { Random.rand(10..30) }
  let(:file_size) { Random.rand(40..200) }
  let(:expected_chunks) do
    (file_size * 1.0 / chunk_size).ceil
  end

  let(:file_content) do
    file_size.times.map { ('a'..'z').to_a.sample }.join('')
  end

  before do
    allow(Settings)
      .to receive(:file_chunk_size)
      .and_return(chunk_size)

    File.open(file_path, 'w') do |f|
      f.write(file_content)
    end
  end

  describe '.process' do
    context 'when no chunk was saved before' do
      it 'reads file into chunks' do
        expect { described_class.process(user_file, file) }
          .to change { user_file.reload.user_file_contents.count }
          .from(0)
          .to(expected_chunks)
      end

      it 'reads the whole file' do
        described_class.process(user_file, file)

        expect(user_file.user_file_contents.pluck(:content).join)
          .to eq(file_content)
      end

      it 'makes user file valid' do
        expect { described_class.process(user_file, file) }
          .to change { user_file.reload.content_valid? }
          .from(false)
          .to(true)
      end

      it 'closes the file' do
        expect { described_class.process(user_file, file) }
          .to change(file, :closed?)
          .from(false)
          .to(true)
      end
    end

    context 'when file is parially saved' do
      let(:first_file) { UserFile::Wrapper.new(file_path) }
      let(:missing_chunks) do
        Random.rand(1..expected_chunks)
      end

      before do
        described_class.process(user_file, first_file)
        user_file
          .reload
          .user_file_contents
          .order(id: :desc)
          .limit(missing_chunks)
          .delete_all
      end

      it 'reads file into chunks' do
        expect { described_class.process(user_file, file) }
          .to change { user_file.reload.user_file_contents.count }
          .from(expected_chunks - missing_chunks)
          .to(expected_chunks)
      end

      it 'reads the whole file' do
        described_class.process(user_file, file)

        expect(user_file.user_file_contents.pluck(:content).join)
          .to eq(file_content)
      end

      it 'makes user file valid' do
        expect { described_class.process(user_file, file) }
          .to change { user_file.reload.content_valid? }
          .from(false)
          .to(true)
      end

      it 'closes the file' do
        expect { described_class.process(user_file, file) }
          .to change(file, :closed?)
          .from(false)
          .to(true)
      end
    end

    context 'when an error occour' do
      let(:user_file) { build(:user_file, size: file_size) }

      it 'closes the file' do
        expect { described_class.process(user_file, file) }
          .to raise_error(ActiveRecord::RecordNotSaved)
          .and change(file, :closed?)
          .from(false)
          .to(true)
      end
    end
  end
end
