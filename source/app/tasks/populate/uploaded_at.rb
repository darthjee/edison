# frozen_string_literal: true

module Populate
  class UploadedAt
    def self.process(*args)
      new(*args).process
    end

    def initialize(limit: 1000)
      @limit = limit
    end

    def process
      while scope.with_valid_content.any?
        scope.with_valid_content
             .update_all('uploaded_at = created_at')
      end
    end

    private

    attr_reader :limit

    def scope
      @scope ||= UserFile
                 .not_deleted
                 .not_uploaded
                 .limit(limit)
    end
  end
end
