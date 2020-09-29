# frozen_string_literal: true

class Folder < ApplicationRecord
  class PathParser
    def self.process(*args)
      new(*args).process
    end

    def initialize(base, user:, parent: nil)
      @base   = base
      @user   = user
      @parent = parent
    end

    def process
      process_files
      process_folders
    end

    private

    attr_reader :base, :user, :parent

    def objects
      @objects ||= Dir["#{base}/*"]
    end

    def folders
      objects.reject { |obj| File.file? obj }
    end

    def files
      objects.select { |obj| File.file? obj }
    end

    def process_folders
      folders.each do |path|
        name = path.gsub(%r{.*/}, '')
        folder = user.folders.find_or_create_by(name: name, folder: parent)
        self.class.process(path, user: user, parent: folder)
      end
    end

    def process_files
      files.each do |path|
        File.open(path, 'r') do |file|
          user.user_files.from_file!(file, parent)
        end
      end
    end
  end
end
