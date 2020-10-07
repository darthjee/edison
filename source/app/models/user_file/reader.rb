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
      result.each do |content|
        yield content.first
        sleep 0.1
      end
    end

    private

    attr_reader :user_file

    delegate :id, to: :user_file

    def result
      ActiveRecord::Base.connection.execute(query)
    end

    def query
      "SELECT content FROM user_file_contents WHERE user_file_id = #{id}"
    end
  end
end
