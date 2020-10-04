# frozen_string_literal: true

class UserFile < ApplicationRecord
  class Decorator < ModelDecorator
    expose :id
    expose :name
    expose :extension
    expose :category
    expose :md5
    expose :size
    expose :uploaded_at

    def uploaded_at
      created_at.to_i
    end
  end
end
