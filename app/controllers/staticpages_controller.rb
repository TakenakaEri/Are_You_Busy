class StaticpagesController < ApplicationController
  # ユーザーIDを返すメソッド
  def get_user_id
    # フォームから入力されたユーザー名を取得
    username = params[:username]
    bearer_token = ENV['BEARER_TOKEN'] # ここにBearerトークンを入力
    # user_idの取得
    url = "https://api.twitter.com/2/users/by/username/#{username}"
    headers = {
      "Authorization": "Bearer #{bearer_token}",
      "Content-Type": "application/json"
    }
    begin
      # ユーザーネームからユーザーIDを取得
      response = RestClient.get(url, headers)
      user_data = JSON.parse(response.body)
      @user_id = user_data["data"]["id"]
      user = User.find_or_initialize_by(uid: @user_id)
      # user.update(uid: @user_id)
      # ユーザーの最新の10件のツイートを取得
      tweets_url = "https://api.twitter.com/2/users/#{@user_id}/tweets?max_results=5"
      tweets_response = RestClient.get(tweets_url, headers)
      tweets_data = JSON.parse(tweets_response.body)
      @tweets = []
      tweets_data["data"].each do |tweet_data|
        tweet = Tweet.find_or_initialize_by(twitter_tweet_id: tweet_data["id"])
        tweet.update(
          twitter_tweet_id: tweet_data["id"],
          text: tweet_data["text"],
          user: user
        )
        @tweets << tweet
      end
      # ツイートIDを取得
      @tweet_ids = @tweets.map(&:twitter_tweet_id)
    rescue RestClient::ExceptionWithResponse => e
      puts e.message
      @error_message = e.response.body
    end
    # リダイレクト前に@user_idをセッションに保存
    session[:user_id] = @user_id
    session[:tweet_ids] = @tweet_ids
    # session[:liked_tweet_ids]が存在する場合はその値を、存在しない場合は空の配列を@liked_tweet_idsに代入
    @liked_tweet_ids = session[:liked_tweet_ids] || []
    render 'top'
  end
  
  def top
    if session[:tweet_ids].present?
      @tweets = Tweet.where(twitter_tweet_id: session[:tweet_ids]).includes(:user).order("created_at desc")
      # session[:liked_tweet_ids]が存在する場合はその値を、存在しない場合は空の配列を@liked_tweet_idsに代入
      @liked_tweet_ids = session[:liked_tweet_ids] || []
    else
      @tweets = Tweet.none
      @liked_tweet_ids = []
    end
  end

  def after_login
    if session[:user_id].present? && session[:tweet_ids].present?
      @user_id = session[:user_id]
      @tweets = Tweet.where(twitter_tweet_id: session[:tweet_ids]).includes(:user).order("created_at desc")
      @tweet_ids = session[:tweet_ids]
      @liked_tweet_ids = session[:liked_tweet_ids] || []
    end
    render 'top'
  end
end
