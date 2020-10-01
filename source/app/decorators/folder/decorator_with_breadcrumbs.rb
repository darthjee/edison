# frozen_string_literal: true

class Folder < ApplicationRecord
  class DecoratorWithBreadcrumbs < Folder::Decorator
    expose :breadcrumbs

    def breadcrumbs
      []
    end
  end
end
