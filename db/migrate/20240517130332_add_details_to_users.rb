class AddDetailsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :screen_name, :string
    add_column :users, :location, :string
    add_column :users, :description, :text
    add_column :users, :followers_count, :integer
    add_column :users, :friends_count, :integer
    add_column :users, :avatar, :string
    add_column :users, :twitter_created_at, :datetime
    add_column :users, :oauth_token, :string
    add_column :users, :oauth_token_secret, :string
  end
end
