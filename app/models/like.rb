class Like < ApplicationRecord
    belongs_to :user, foreign_key: 'uid'
    belongs_to :tweet
end
