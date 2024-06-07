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
      puts "user_id: #{@user_id}"

      user = User.find_or_initialize_by(uid: @user_id)
      # user.update(uid: @user_id)

      # ユーザーの最新の10件のツイートを取得
      tweets_url = "https://api.twitter.com/2/users/#{@user_id}/tweets"
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

      # ツイートが保存できているか確認
      puts "保存したツイート:"
      @tweets.each { |tweet| puts "Tweet: #{tweet.inspect}" }

      # ツイートIDを取得
      @tweet_ids = @tweets.map(&:twitter_tweet_id)

    rescue RestClient::ExceptionWithResponse => e
      puts e.message
      @error_message = e.response.body
    end

    # リダイレクト前に@user_idをセッションに保存
    session[:user_id] = @user_id

    render 'top'
  end

  def top
    @tweets = Tweet.includes(:user).order("created_at desc")
  end
end
