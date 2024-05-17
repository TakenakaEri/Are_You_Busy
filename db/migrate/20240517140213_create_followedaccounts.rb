class CreateFollowedaccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :followedaccounts do |t|
      t.integer :user_id
      t.string :uid

      t.timestamps
    end
  end
end
