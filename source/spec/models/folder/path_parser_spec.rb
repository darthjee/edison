# frozen_string_literal: true

require 'spec_helper'
require 'fileutils'

describe Folder::PathParser do
  let(:base)           { "/tmp/base-#{Random.rand(1000)}" }
  let(:path)           { "#{base}/folder1/folder2" }
  let(:file_name)      { "file-#{Random.rand(1000)}.txt" }
  let(:file_path)      { "#{path}/#{file_name}" }
  let(:user)           { create(:user) }
  let(:root_file_path) { "#{base}/#{file_name}" }

  before do
    FileUtils.mkdir_p(path)
    File.open(file_path, 'w') { |f| f.write('ee') }
    File.open(root_file_path, 'w') { |f| f.write('aaa') }
  end

  after do
    FileUtils.rm_rf(base)
    FileUtils.rm_rf(root_file_path)
  end

  describe '.process' do
    it do
      expect { described_class.process(base, user: user) }
        .to change { user.folders.reload.count }
        .by(2)
    end

    it do
      expect { described_class.process(base, user: user) }
        .to change { user.user_files.reload.count }
        .by(2)
    end

    context 'when processing is done' do
      before { described_class.process(base, user: user) }

      it 'creates folders nesting' do
        expect(user.folders.first.folders.first)
          .to eq(user.folders.second)
      end

      it 'creates file for base folder' do
        expect(user.user_files.first.folder)
          .to be_nil
      end

      it 'creates file for inner folder' do
        expect(user.user_files.last.folder)
          .to eq(user.folders.second)
      end
    end

    context 'when one of the folders already exist' do
      before do
        user.folders.create(name: :folder1)
      end

      it do
        expect { described_class.process(base, user: user) }
          .to change { user.folders.reload.count }
          .by(1)
      end

      it do
        expect { described_class.process(base, user: user) }
          .to change { user.user_files.reload.count }
          .by(2)
      end

      context 'when processing is done' do
        before { described_class.process(base, user: user) }

        it 'creates file for base folder' do
          expect(user.user_files.first.folder)
            .to be_nil
        end

        it 'creates file for inner folder' do
          expect(user.user_files.last.folder)
            .to eq(user.folders.second)
        end
      end
    end

    context 'when one of the folders already exist and it has been delted' do
      let!(:existing_folder) do
        user.folders.create(name: :folder1, deleted_at: 1.day.ago)
      end

      let!(:deleted_file) do
        create(:user_file, folder: existing_folder, deleted_at: 1.day.ago)
      end

      it do
        expect { described_class.process(base, user: user) }
          .to change { user.folders.reload.count }
          .by(1)
      end

      it do
        expect { described_class.process(base, user: user) }
          .to change { user.user_files.reload.count }
          .by(2)
      end

      it do
        expect { described_class.process(base, user: user) }
          .to change { existing_folder.reload.deleted_at }
          .to(nil)
      end

      it do
        expect { described_class.process(base, user: user) }
          .not_to(change { deleted_file.reload.deleted_at })
      end

      context 'when processing is done' do
        before { described_class.process(base, user: user) }

        it 'creates file for base folder' do
          expect(user.user_files.first.folder)
            .to be_nil
        end

        it 'creates file for inner folder' do
          expect(user.user_files.last.folder)
            .to eq(user.folders.second)
        end
      end
    end

    context 'when all folders already exist' do
      let(:folder_1) do
        user.folders.create(name: :folder1)
      end

      before do
        user.folders.create(name: :folder2, folder: folder_1)
      end

      it do
        expect { described_class.process(base, user: user) }
          .not_to(change { user.folders.reload.count })
      end

      it do
        expect { described_class.process(base, user: user) }
          .to change { user.user_files.reload.count }
          .by(2)
      end

      context 'when processing is done' do
        before { described_class.process(base, user: user) }

        it 'creates file for base folder' do
          expect(user.user_files.first.folder)
            .to be_nil
        end

        it 'creates file for inner folder' do
          expect(user.user_files.last.folder)
            .to eq(user.folders.second)
        end
      end
    end

    context 'when root file and folder already exist' do
      let(:folder_1) do
        user.folders.create(name: :folder1)
      end

      before do
        user.folders.create(name: :folder2, folder: folder_1)

        user.user_files.from_file!(root_file_path, nil)
      end

      it do
        expect { described_class.process(base, user: user) }
          .not_to(change { user.folders.reload.count })
      end

      it do
        expect { described_class.process(base, user: user) }
          .to change { user.user_files.reload.count }
          .by(1)
      end

      context 'when processing is done' do
        before { described_class.process(base, user: user) }

        it 'creates file for base folder' do
          expect(user.user_files.first.folder)
            .to be_nil
        end

        it 'creates file for inner folder' do
          expect(user.user_files.last.folder)
            .to eq(user.folders.second)
        end
      end
    end

    context 'when inner file already exist' do
      let(:folder_1) do
        user.folders.create(name: :folder1)
      end

      let(:folder_2) do
        user.folders.create(name: :folder2, folder: folder_1)
      end

      before do
        user.user_files.from_file!(file_path, folder_2)
      end

      it do
        expect { described_class.process(base, user: user) }
          .not_to(change { user.folders.reload.count })
      end

      it do
        expect { described_class.process(base, user: user) }
          .to change { user.user_files.reload.count }
          .by(1)
      end

      context 'when processing is done' do
        before { described_class.process(base, user: user) }

        it 'creates file for base folder' do
          expect(user.user_files.second.folder)
            .to be_nil
        end

        it 'creates file for inner folder' do
          expect(user.user_files.first.folder)
            .to eq(user.folders.second)
        end
      end
    end
  end
end
