class ChangeUserFileContentsIdType < ActiveRecord::Migration[5.2]
  def up
    execute "ALTER TABLE user_file_contents CHANGE id id BIGINT(30) auto_increment"
  end

  def down
    execute "ALTER TABLE user_file_contents CHANGE id id BIGINT(20) auto_increment"
  end
end
