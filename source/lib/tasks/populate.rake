# frozen_string_literal: true

namespace :populate do
  desc 'Populate all that needs populating'
  task all: :environment do
    Rake::Task['populate:file_updated_at'].invoke
  end

  desc 'Populates something'
  task file_updated_at: :environment do
    Populate::UploadedAt.process
  end
end
