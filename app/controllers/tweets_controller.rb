class TweetsController < ApplicationController
  require 'net/http'
  require 'uri'
  require 'json'
  

  def index
    @tweets = []
    if params[:username].present?
      user_id = TwitterApiService.get_user_id(params[:username])
      @tweets = TwitterApiService.get_user_tweets(user_id) if user_id
    end
  end

  # def show
  # end

  def new
    @username = params[:username]
    @tweets = fetch_tweets(@username)
  end

  # def create
  # end

  # def edit
  # end

  # def update
  # end

  # def destroy
  # end
end

private


# def fetch_tweets(uid)
#   # Twitter APIクライアントの初期化
#   client = X::Client.new(**X_CREDENTIALS)
#   # ユーザーの情報を取得
#   # user = client.get("/2/users/#{uid}/tweets")
#   user = client.get("https://api.twitter.com/2/users/6puE0DDrbM66073/tweets")
#   # 10件の最新のツイートを取得
#   user.data.tweets(count: 10)
# rescue X::Error => e
#   Rails.logger.error "Twitter API Error: #{e.message}"
#   []
# end


# def fetch_tweets(username)
#   # Twitter APIクライアントの初期化
#   client = X::Client.new(**X_CREDENTIALS)
#   # ユーザー名からユーザーIDを取得
#   user_id = client.get_user_id(username)
#   # ユーザーの情報を取得
#   user = client.get("/2/users/#{user_id}/tweets")
#   # 10件の最新のツイートを取得
#   user.data.tweets(count: 10)
# rescue X::Error => e
#   Rails.logger.error "Twitter API Error: #{e.message}"
#   []
# end

# ユーザーネームを入力するとユーザーIDを取得し、そのユーザーの最新のツイートを取得する
def fetch_tweets(username)
  # Twitter APIクライアントの初期化
  client = X::Client.new(**X_CREDENTIALS)
  # ユーザー名からユーザー情報を取得
  user_info_response = client.get("/2/users/by/username/#{username}")
  user_id = user_info_response.data.id
  # ユーザーIDからユーザーのツイートを取得
  tweets_response = client.get("/2/users/#{user_id}/tweets")
  # 10件の最新のツイートを取得
  tweets = tweets_response.data.take(10)
rescue X::Error => e
  Rails.logger.error "Twitter API Error: #{e.message}"
  []
end