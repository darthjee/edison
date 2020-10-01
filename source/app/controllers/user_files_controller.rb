# frozen_string_literal: true

class UserFilesController < ApplicationController
  include OnePageApplication
  include FolderAccessible

  resource_for :user_file, only: %i[index show]
  before_action :check_logged!

  private

  def user_files
    @user_files ||= objects
  end

  def all_objects
    logged_user.user_files
  end
end
