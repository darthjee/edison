# frozen_string_literal: true

class UserFile < ApplicationRecord
  class ChunkSaver
    def self.process(*args)
      new(*args).process
    end

    def initialize(user_file, file)
      @user_file = user_file
      @file      = file
    end

    def process
      loop do
        break if eof?

        save_chunk
      end
    ensure
      close
    end

    private

    attr_reader :user_file, :file
    delegate :eof?, :close, to: :file

    def content_chunk
      file.read(Settings.file_chunk_size)
    end

    def save_chunk
      user_file.user_file_contents.create(
        content: content_chunk
      )
    end
  end
end
