class ChangeTwitterTweetIdToStringInTweets < ActiveRecord::Migration[7.1]
  def change
    change_column :tweets, :twitter_tweet_id, :string
  end
end
