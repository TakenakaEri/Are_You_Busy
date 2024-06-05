# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_06_05_103512) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookmarks", force: :cascade do |t|
    t.integer "user_id"
    t.string "tweet_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "followedaccounts", force: :cascade do |t|
    t.integer "user_id"
    t.string "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "likes", force: :cascade do |t|
    t.integer "user_id"
    t.string "tweet_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tweets", force: :cascade do |t|
    t.string "uid"
    t.string "twitter_tweet_id"
    t.text "text"
    t.integer "user_id"
    t.integer "tweet_created_at"
    t.integer "retweet_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["twitter_tweet_id"], name: "index_tweets_on_twitter_tweet_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.bigint "uid"
    t.string "screen_name"
    t.string "location"
    t.text "description"
    t.integer "followers_count"
    t.integer "friends_count"
    t.string "avatar"
    t.datetime "twitter_created_at"
    t.string "oauth_token"
    t.string "oauth_token_secret"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "refresh_token"
    t.datetime "expires_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["oauth_token"], name: "index_users_on_oauth_token", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid"], name: "index_users_on_uid", unique: true
  end

  add_foreign_key "bookmarks", "tweets", primary_key: "twitter_tweet_id"
  add_foreign_key "bookmarks", "users"
  add_foreign_key "followedaccounts", "users"
  add_foreign_key "likes", "tweets", primary_key: "twitter_tweet_id"
  add_foreign_key "likes", "users"
  add_foreign_key "likes", "users", primary_key: "uid"
  add_foreign_key "tweets", "users"
end
