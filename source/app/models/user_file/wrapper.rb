# frozen_string_literal: true

class UserFile < ApplicationRecord
  class Wrapper
    delegate :close, :path, :eof?, :read, to: :file

    def initialize(file)
      if file.is_a?(File)
        @file = file
      else
        @file_path = file
      end
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

    def md5sum
      `md5sum #{path}`.gsub(/ .*\n/, '')
    end

    private

    attr_reader :file_path

    def file
      @file ||= File.open(file_path, 'r')
    end

    def extract_extension
      match = name.match(/\.(?<ext>[^.]*)$/)
      return '' unless match

      match[:ext].downcase
    end
  end
end
