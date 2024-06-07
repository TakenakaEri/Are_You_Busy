class AddUniqueIndexToTweetTwitterTweetId < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :bookmarks, column: :tweet_id
    remove_index :tweets, :twitter_tweet_id if index_exists?(:tweets, :twitter_tweet_id)
    add_index :tweets, :twitter_tweet_id, unique: true
  end
end
