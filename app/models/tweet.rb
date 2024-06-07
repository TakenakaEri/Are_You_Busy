class Tweet < ApplicationRecord
    belongs_to :user, foreign_key: 'uid', primary_key: 'uid'

    has_many :likes, dependent: :destroy
    has_many :bookmarks, dependent: :destroy

end
