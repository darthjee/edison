# frozen_string_literal: true

class Folder < ApplicationRecord
  class DecoratorWithBreadcrumbs < Folder::Decorator
    expose :breadcrumbs, decorator: Folder::Decorator

    def breadcrumbs
      parent = folder

      [].tap do |list|
        loop do
          break unless parent

          list.unshift(parent)
          parent = parent.folder
        end
      end
    end
  end
end
