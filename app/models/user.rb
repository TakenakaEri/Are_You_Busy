class User < ApplicationRecord
    has_many :tweets
    has_many :bookmarks
    has_many :likes
    has_many :followed_accounts
end
