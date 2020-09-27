# frozen_string_literal: true

class Settings
  extend Sinclair::EnvSettable

  settings_prefix 'EDISON'

  with_settings(
    :password_salt,
    hex_code_size: 16,
    session_period: 2.days,
    cache_age: 10.seconds,
    file_chunk_size: UserFileContent::BLOB_LIMIT
  )
end
