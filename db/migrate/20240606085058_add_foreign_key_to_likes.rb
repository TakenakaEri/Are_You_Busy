class AddForeignKeyToLikes < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :likes, column: :tweet_id
  end
end
