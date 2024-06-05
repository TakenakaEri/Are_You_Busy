class Tweet < ApplicationRecord
    belongs_to :user

    has_many :likes, foreign_key: 'twitter_tweet_id'
    has_many :bookmarks, dependent: :destroy
end
