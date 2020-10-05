# frozen_string_literal: true

class UserFile < ApplicationRecord
  class ParserScopes
    def initialize(relation, file, folder)
      @relation = relation
      @file     = file
      @folder   = folder
    end

    def user_file
      @user_file ||= (scope.first || creation_scope.create)
    end

    def old_entries
      @old_entries ||= name_scope
                       .not_deleted
                       .where.not(id: user_file.id)
    end

    private

    attr_reader :relation, :file, :folder

    delegate :name, :extension, :category,
             :size, :md5sum, to: :file

    def creation_scope
      scope.where(
        extension: extension,
        category: category
      )
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
