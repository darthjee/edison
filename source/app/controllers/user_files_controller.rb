# frozen_string_literal: true

class UserFilesController < ApplicationController
  include OnePageApplication
  include FolderAccessible

  resource_for :user_file, only: %i[index show]
  before_action :check_logged!

  def download
    response.set_header(
      'Content-Type', Rack::Mime::MIME_TYPES[user_file.extension]
    )
    response.set_header(
      'ETag', user_file.md5
    )
    response.set_header(
      'Content-Disposition', "attachment; filename=\"#{user_file.name}\""
    )
    response.set_header("Content-Length", user_file.size)

    user_file.read do |chunk|
      response.stream.write chunk
    end
  ensure
    response.stream.close
  end

  private

  def user_files
    @user_files ||= objects
  end

  def all_objects
    logged_user.user_files
  end
end
