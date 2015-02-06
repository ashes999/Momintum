class AddUsernameToUsers < ActiveRecord::Migration
  def change
    # add_column on SQLite can't add a non-null column without a default. #fail
    add_column :users, :username, :string, null: false, default: ''
    add_index :users, :username, unique: true
  end
end
