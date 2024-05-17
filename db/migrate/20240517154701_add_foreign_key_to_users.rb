class AddForeignKeyToUsers < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :bookmarks, :users
    add_foreign_key :followedaccounts, :users
    add_foreign_key :likes, :users
    add_foreign_key :tweets, :users
    
    add_index :users, :uid, unique: true
    add_index :users, :oauth_token, unique: true
  end
end
