# frozen_string_literal: true

class UserFile < ApplicationRecord
  class FileParser
    def self.process(*args)
      new(*args).process
    end

    def initialize(relation, file)
      @relation = relation
      @file     = file
    end

    def process
      ActiveRecord::Base.transaction do
        user_file.tap { save_chunks }
      end
    end

    private

    attr_reader :relation, :file
    delegate :eof?, :path, to: :file

    def user_file
      @user_file ||= relation.create(
        name: name,
        extension: extension,
        md5: md5,
        category: category,
        size: size
      )
    end

    def name
      @name ||= path.gsub(%r{.*/}, '')
    end

    def extension
      @extension ||= extract_extension
    end

    def category
      FileCategory.from(extension)
    end

    def size
      `wc -c #{path}`.gsub(/ .*\n/, '').to_i
    end

    def extract_extension
      match = name.match(/\.(?<ext>[^.]*)$/)
      return '' unless match

      match[:ext]
    end

    def md5
      `md5sum #{path}`.gsub(/ .*\n/, '')
    end

    def content_chunk
      file.read(Settings.file_chunk_size)
    end

    def save_chunk
      user_file.user_file_contents.create(
        content: content_chunk
      )
    end

    def save_chunks
      loop do
        break if eof?

        save_chunk
      end
    end
  end
end
