# frozen_string_literal: true

class FoldersController < ApplicationController
  include OnePageApplication
  include FolderAccessible

  resource_for :folder, only: %i[index show]
  before_action :check_logged!

  private

  alias all_objects user_folders

  def folders
    @folders ||= objects
  end

  def folder
    return Folder.new if folder_id.to_i.zero?

    folders.find(folder_id)
  end
end
