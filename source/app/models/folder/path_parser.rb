# frozen_string_literal: true

class Folder < ApplicationRecord
  class PathParser
    def self.process(*args)
      new(*args).process
    end

    def initialize(base, user:, parent: nil, log: false)
      @base   = base
      @user   = user
      @parent = parent
      @log    = log
    end

    def process
      process_files
      process_folders
    end

    private

    attr_reader :base, :user, :parent, :log

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
        info("Processing folder #{path}")
        self.class.process(
          path,
          user: user,
          parent: retrieve_folder(path),
          log: log
        )
      end
    end

    def process_files
      files.each do |path|
        info("Processing file #{path}")
        user.user_files.from_file!(path, parent)
      end
    end

    def retrieve_folder(path)
      name = path.gsub(%r{.*/}, '')

      user.folders.find_or_create_by(
        name: name, folder: parent
      ).tap(&:undelete)
    end

    def info(message)
      puts message if log
    end
  end
end
