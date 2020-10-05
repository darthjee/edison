# frozen_string_literal: true

class Folder < ApplicationRecord
  class Wrapper
    def initialize(folder)
      @folder = folder
    end

    def folders
      objects.reject { |obj| File.file? obj }
    end

    def files
      objects.select { |obj| File.file? obj }
    end

    private

    attr_reader :folder

    def objects
      @objects ||= Dir["#{folder}/*"]
    end
  end
end
