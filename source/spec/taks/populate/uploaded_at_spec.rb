# frozen_string_literal: true

require 'spec_helper'

describe Populate::UploadedAt do
  let(:deleted_at)  { nil }
  let(:uploaded_at) { nil }

  let!(:valid_user_file) do
    create(
      :user_file,
      size: size,
      deleted_at: deleted_at,
      uploaded_at: uploaded_at
    )
  end

  let!(:invalid_user_file) do
    create(
      :user_file,
      size: size + 1,
      deleted_at: deleted_at
    )
  end

  let!(:valid_user_files) do
    create_list(
      :user_file,
      10,
      size: size,
      uploaded_at: nil
    )
  end

  let!(:invalid_user_files) do
    create_list(
      :user_file,
      10,
      size: size + 1,
      uploaded_at: nil
    )
  end

  let(:chunks) { %w[this is a super valid content] }
  let(:size)   { chunks.join.size }

  before do
    chunks.each do |chunk|
      UserFile.all.each do |user_file|
        create(
          :user_file_content,
          user_file: user_file,
          content: chunk
        )
      end
    end
  end

  describe '.process' do
    it do
      expect { described_class.process }
        .not_to(change { invalid_user_file.reload.uploaded_at })
    end

    it do
      expect(invalid_user_file.uploaded_at).to be_nil
    end

    it do
      expect { described_class.process }
        .to change { valid_user_file.reload.uploaded_at }
        .from(nil)
        .to(valid_user_file.created_at)
    end

    context 'when files have been deleted' do
      let(:deleted_at) { 1.day.ago }

      it do
        expect { described_class.process }
          .not_to(change { invalid_user_file.reload.uploaded_at })
      end

      it do
        expect(invalid_user_file.uploaded_at).to be_nil
      end

      it do
        expect { described_class.process }
          .not_to(change { valid_user_file.reload.uploaded_at })
      end

      it do
        expect(valid_user_file.uploaded_at).to be_nil
      end
    end

    context 'when files have marked as uploaded alread' do
      let(:uploaded_at) { 1.day.ago }

      it do
        expect { described_class.process }
          .not_to(change { invalid_user_file.reload.uploaded_at })
      end

      it do
        expect(invalid_user_file.uploaded_at).to be_nil
      end

      it do
        expect { described_class.process }
          .not_to(change { valid_user_file.reload.uploaded_at })
      end

      it do
        expect(valid_user_file.uploaded_at).not_to be_nil
      end
    end

    context 'when there are many files' do
      before { described_class.process(limit: 1) }

      it do
        expect(invalid_user_files.map { |f| f.reload.uploaded_at })
          .to all(be_nil)
      end

      it do
        expect(valid_user_files.map { |f| f.reload.uploaded_at })
          .to all(not_be_nil)
      end
    end
  end
end
