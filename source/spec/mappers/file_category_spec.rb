# frozen_string_literal: true

require 'spec_helper'

describe FileCategory do
  describe '.from_map' do
    let(:extension) { extensions.sample }

    context 'when extension is for an stl' do
      let(:extension) { 'stl' }

      it do
        expect(described_class.from(extension))
          .to eq('3d')
      end
    end

    context 'when extension is for an image' do
      let(:extensions) do
        %w[jpg jpeg gif bmp tif tiff]
      end

      it do
        expect(described_class.from(extension))
          .to eq('image')
      end
    end

    context 'when extension is for book' do
      let(:extensions) do
        %w[mobi epub pdf]
      end

      it do
        expect(described_class.from(extension))
          .to eq('book')
      end
    end

    context 'when extension is for video' do
      let(:extensions) do
        %w[avi mp4 mkv]
      end

      it do
        expect(described_class.from(extension))
          .to eq('video')
      end
    end

    context 'when extension is for music' do
      let(:extensions) do
        %w[wav mp3]
      end

      it do
        expect(described_class.from(extension))
          .to eq('audio')
      end
    end

    context 'when extension is for signature' do
      let(:extension) { 'sig' }

      it do
        expect(described_class.from(extension))
          .to eq('pgp-signature')
      end
    end

    context 'when extension is for zip' do
      let(:extensions) do
        %w[zip 7z rar gz tar]
      end

      it do
        expect(described_class.from(extension))
          .to eq('compressed')
      end
    end

    context 'when extension was not defined' do
      let(:extension) { 'bizar' }

      it do
        expect(described_class.from(extension))
          .to eq('misc')
      end
    end
  end
end
