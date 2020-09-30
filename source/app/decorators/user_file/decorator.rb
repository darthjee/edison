# frozen_string_literal: true

class UserFile < ApplicationRecord
  class Decorator < ModelDecorator
    expose :id
    expose :name
    expose :extension
    expose :category
    expose :md5
    expose :size
  end
end
