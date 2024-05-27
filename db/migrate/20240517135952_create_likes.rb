class CreateLikes < ActiveRecord::Migration[7.1]
  def change
    create_table :likes do |t|
      t.integer :user_id
      t.string :tweet_id

      t.timestamps
    end
  end
end
