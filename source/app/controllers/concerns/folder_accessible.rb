# frozen_string_literal: true

module FolderAccessible
  extend ActiveSupport::Concern
  include LoggedUser

  def objects
    all_objects.not_deleted.where(folder: parent_folder)
  end

  def parent_folder
    return nil if parent_folder_id.zero?

    user_folders.find(parent_folder_id)
  end

  def parent_folder_id
    params[:folder_id].to_i
  end

  def user_folders
    @user_folders ||= logged_user.folders.not_deleted
  end
end
