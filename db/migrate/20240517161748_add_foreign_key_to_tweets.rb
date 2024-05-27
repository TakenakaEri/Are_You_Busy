class AddForeignKeyToTweets < ActiveRecord::Migration[7.1]
  def change
    add_index :tweets, :twitter_tweet_id, unique: true
    add_foreign_key :bookmarks, :tweets, column: :tweet_id, primary_key: :twitter_tweet_id
    add_foreign_key :likes, :tweets, column: :tweet_id, primary_key: :twitter_tweet_id
  end
end
