# frozen_string_literal: true

class Settings
  extend Sinclair::EnvSettable

  settings_prefix 'EDISON'

  with_settings(
    :password_salt,
    cache_age: 10.seconds,
    favicon: '/favicon.ico',
    file_chunk_size: UserFileContent::BLOB_LIMIT,
    hex_code_size: 16,
    session_period: 2.days,
    title: 'Edison',
    upload_folder: '/home/app/app/upload'
  )
end
