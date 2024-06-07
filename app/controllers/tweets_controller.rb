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

private

  # ユーザーネームを入力するとユーザーIDを取得し、そのユーザーの最新のツイートを取得する
  def fetch_tweets(username)
    # Twitter APIクライアントの初期化
    client = TWITTER_CLIENT
    # ユーザー名からユーザー情報を取得
    user_info_response = client.user(username)
    user_id = user_info_response.id
    # ユーザーIDからユーザーのツイートを取得
    tweets_response = client.user_timeline(user_id)
    # 10件の最新のツイートを取得
    tweets = tweets_response.take(10)
  rescue Twitter::Error => e
    Rails.logger.error "Twitter API Error: #{e.message}"
    []
  end

end