class Tweet < ApplicationRecord
    belongs_to :user

    has_many :likes
    has_many :bookmarks, dependent: :destroy
end
