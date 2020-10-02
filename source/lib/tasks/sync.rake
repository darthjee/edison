# frozen_string_literal: true

namespace :sync do
  desc 'upload files'
  task :upload, [:user_id] => :environment do |_t, args|
    user_id = args[:user_id]

    user = User.find(user_id)
    puts "uploading files to [#{user_id}] #{user.login}"

    Folder::PathParser.process(Settings.upload_folder, user: user, log: true)
  end
end
