# frozen_string_literal: true

class FoldersController < ApplicationController
  include OnePageApplication
  include LoggedUser

  resource_for :folder, only: %i[index]
  before_action :check_logged!

  private

  delegate :folders, to: :logged_user

  def folders
    @folders ||= scoped_folders
  end

  def scoped_folders
    return user_folders.root unless parent_folder_id

    user_folders.find(parent_folder_id).folders
  end

  def user_folders
    logged_user.folders
  end

  def parent_folder_id
    params[:folder_id]
  end
end
