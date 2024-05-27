class RenameTweetIdInTweets < ActiveRecord::Migration[7.1]
  def change
    rename_column :tweets, :tweet_id, :twitter_tweet_id
  end
end
