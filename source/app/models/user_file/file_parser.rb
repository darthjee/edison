# frozen_string_literal: true

class UserFile < ApplicationRecord
  class FileParser
    def self.process(*args)
      new(*args).process
    end

    def initialize(relation, file, folder)
      @relation = relation
      @file     = Wrapper.new(file)
      @folder   = folder
    end

    def process
      ActiveRecord::Base.transaction do
        delete_old_entries

        user_file.tap(&:undelete)
      end
    end

    private

    attr_reader :relation, :file, :folder

    delegate :path, :name, :extension, :category,
             :size, :md5sum, to: :file

    def user_file
      @user_file ||= find_or_create_user_file
    end

    def find_or_create_user_file
      return scope.first if scope.any?

      create_user_file
    end

    def create_user_file
      scope.create(
        extension: extension,
        category: category
      ).tap do |entry|
        ChunkSaver.process(entry, file)
        file.close
      end
    end

    def delete_old_entries
      name_scope
        .not_deleted
        .update_all(deleted_at: Time.now)
    end

    def scope
      @scope ||= name_scope.where(
        md5: md5sum,
        size: size
      )
    end

    def name_scope
      @name_scope ||= relation.where(
        name: name,
        folder: folder
      )
    end
  end
end
