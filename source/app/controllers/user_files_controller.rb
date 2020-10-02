# frozen_string_literal: true

class UserFilesController < ApplicationController
  include OnePageApplication
  include FolderAccessible

  resource_for :user_file, only: %i[index show]
  before_action :check_logged!
  before_action :set_download_headers, only: :download

  def download
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

  def set_download_headers
    download_headers.each do |key, value|
      response.set_header(key, value)
    end
  end

  def download_headers
    {
      'Content-Type' => Rack::Mime::MIME_TYPES[".#{user_file.extension}"],
      'ETag' => user_file.md5,
      'Content-Disposition' => "attachment; filename=\"#{user_file.name}\"",
      'Content-Length' => user_file.size
    }
  end
end
