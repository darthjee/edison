# frozen_string_literal: true

class Folder < ApplicationRecord
  class DecoratorWithBreadcrumbs < Folder::Decorator
    expose :breadcrumbs

    def breadcrumbs
      1
    end
  end
end
