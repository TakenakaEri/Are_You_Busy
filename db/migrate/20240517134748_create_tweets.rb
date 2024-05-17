class CreateTweets < ActiveRecord::Migration[7.1]
  def change
    create_table :tweets do |t|
      t.string :uid
      t.string :tweet_id
      t.text :text
      t.integer :user_id
      t.integer :tweet_created_at
      t.integer :retweet_count

      t.timestamps
    end
  end
end
