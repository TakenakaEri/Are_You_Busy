class CreateBookmarks < ActiveRecord::Migration[7.1]
  def change
    create_table :bookmarks do |t|
      t.integer :user_id
      t.string :tweet_id

      t.timestamps
    end
  end
end
