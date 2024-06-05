class Like < ApplicationRecord
    belongs_to :user
    belongs_to :tweet, foreign_key: 'twitter_tweet_id', primary_key: 'twitter_tweet_id'
end
