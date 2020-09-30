# frozen_string_literal: true

module FolderAccessible
  extend ActiveSupport::Concern
  include LoggedUser

  def objects
    all_objects.not_deleted.where(folder: parent_folder)
  end

  def parent_folder
    return nil unless parent_folder_id

    logged_user.folders.find(parent_folder_id)
  end

  def parent_folder_id
    params[:folder_id]
  end
end
