# frozen_string_literal: true

# This file should contain all the record creation
# needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed
# command (or created alongside the database with db:setup).
#

class Seeder
  def user
    @user ||= find_or_create_user
  end

  def root_file
    @root_file ||= create_root_file
  end

  def inner_file
    @inner_file ||= create_inner_file
  end

  def internal_file
    @internal_file ||= create_internal_file
  end

  private

  def root_folder
    @root_folder ||= user.folders.find_or_create_by(
      name: :folder1
    )
  end

  def inner_folder
    @inner_folder ||= root_folder.folders.find_or_create_by(
      name: :folder2,
      user: user
    )
  end

  def internal_folder
    @internal_folder ||= inner_folder.folders.find_or_create_by(
      name: :folder3,
      user: user
    )
  end

  def find_or_create_user
    @user = User.find_or_initialize_by(
      name: 'User',
      login: 'darthjee',
      email: 'darthjee@srv.com'
    )
    user.password = 'password'
    user.tap(&:save)
  end

  def create_root_file
    create_file('file1', %w[this is a content])
  end

  def create_inner_file
    create_file(
      'file2',
      %w[this is an inner content],
      folder: root_folder
    )
  end

  def create_internal_file
    create_file(
      'file3',
      %w[this is super internal content],
      folder: inner_folder
    )
  end

  def create_file(name, contents, folder: nil)
    find_or_initialize_file(name, contents, folder).tap do |file|
      unless file.persisted?
        file.save
        contents.each do |chunk|
          file.user_file_contents.create(content: chunk)
        end
      end
    end
  end

  def find_or_initialize_file(name, contents, folder)
    user.user_files.find_or_initialize_by(
      name: "#{name}.txt",
      folder: folder,
      extension: 'txt',
      category: 'text',
      md5: md5sum(contents),
      size: contents.join.size
    )
  end

  def md5sum(contents)
    Digest::MD5.hexdigest contents.join
  end
end

seeder = Seeder.new
seeder.user
seeder.root_file
seeder.inner_file
seeder.internal_file
seeder.send(:internal_folder)
