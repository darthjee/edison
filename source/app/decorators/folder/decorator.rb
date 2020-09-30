# frozen_string_literal: true

class Folder < ApplicationRecord
  class Decorator < ModelDecorator
    expose :id
    expose :name
  end
end
