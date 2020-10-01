# frozen_string_literal: true

class FoldersController < ApplicationController
  include OnePageApplication
  include FolderAccessible

  resource_for :folder, only: %i[index]
  resource_for :folder,
    only: %i[show],
    decorator: Folder::DecoratorWithBreadcrumbs
  before_action :check_logged!

  private

  alias all_objects user_folders

  def folders
    @folders ||= objects
  end

  def folder
    return Folder.new if folder_id.to_i.zero?

    user_folders.find(folder_id)
  end
end
