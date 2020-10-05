# frozen_string_literal: true

class Folder < ApplicationRecord
  class PathParser
    def self.process(*args)
      new(*args).process
    end

    def initialize(folder, user:, parent: nil, log: false)
      @folder = Wrapper.new(folder)
      @user   = user
      @parent = parent
      @log    = log
    end

    def process
      process_files
      process_folders
    end

    private

    attr_reader :folder, :user, :parent, :log
    delegate :folders, :files, to: :folder

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
      files.each { |path| process_file(path) }
    end

    def process_file(path)
      info("Processing file #{path}")
      user.user_files.from_file!(path, parent)
    rescue Mysql2::Error,
           ActiveRecord::StatementInvalid,
           ActiveRecord::RecordNotSaved => e
      info('ERROR ' * 4)
      info(e.message)
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
