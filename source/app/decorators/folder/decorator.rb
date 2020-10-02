# frozen_string_literal: true

class Folder < ApplicationRecord
  class Decorator < ModelDecorator
    expose :id
    expose :name
    expose :folder_id, as: :parent_id
  end
end
