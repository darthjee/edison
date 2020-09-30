# frozen_string_literal: true

class FoldersController < ApplicationController
  include OnePageApplication
  include FolderAccessible

  resource_for :folder, only: %i[index]
  before_action :check_logged!

  private

  def folders
    @folders ||= objects
  end

  def all_objects
    logged_user.folders
  end
end
