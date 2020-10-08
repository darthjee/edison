# frozen_string_literal: true

class UserFile < ApplicationRecord
  class Reader
    def self.read(user_file, &block)
      new(user_file).read(&block)
    end

    def initialize(user_file)
      @user_file = user_file
    end

    def read
      loop do
        break unless scoped_content.any?

        chunk = scoped_content.first
        yield chunk.content
        Rails.logger.error("READING CHUNK #{chunk.id}")

        next_content
      end
    end

    private

    attr_reader :user_file

    delegate :user_file_contents, to: :user_file

    def scoped_content
      user_file_contents.offset(index).limit(1)
    end

    def index
      @index ||= 0
    end

    def next_content
      @index += 1
    end
  end
end
