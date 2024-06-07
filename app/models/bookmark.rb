class Bookmark < ApplicationRecord
    belongs_to :user, foreign_key: 'uid', primary_key: 'uid'
    belongs_to :tweet
end
