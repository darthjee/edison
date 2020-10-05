# frozen_string_literal: true

class UserFile < ApplicationRecord
  class FileParser
    def self.process(*args)
      new(*args).process
    end

    def initialize(relation, file_path, folder)
      @relation = relation
      @file     = Wrapper.new(file_path)
      @folder   = folder
    end

    def process
      process_file
    end

    private

    attr_reader :relation, :file, :folder

    delegate :path, :name, :extension, :category,
             :size, :md5sum, to: :file
    delegate :content_valid?, to: :user_file
    delegate :user_file, :old_entries, to: :finder_creator

    def process_file
      ChunkSaver.process(user_file, file) unless content_valid?

      ActiveRecord::Base.transaction do
        delete_old_entries
        user_file.tap(&:mark_uploaded)
      end
    end

    def finder_creator
      @finder_creator ||= ParserScopes.new(relation, file, folder)
    end

    def delete_old_entries
      old_entries
        .update_all(deleted_at: Time.now)
    end
  end
end
