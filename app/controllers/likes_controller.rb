class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_tweet, only: [:create, :destroy]

  def create
    @tweet = Tweet.find_by(twitter_tweet_id: params[:tweet_id])
    @like = current_user.likes.new(tweet: @tweet)


    # デバッグ情報を追加
    puts "カレントユーザー: #{current_user.inspect}"
    puts "Twitter Tweet ID: #{@tweet.twitter_tweet_id}"

    bearer_token = ENV['BEARER_TOKEN']

    url = "https://api.twitter.com/2/users/#{current_user.uid}/likes"

    headers = {
      "Authorization": "Bearer #{bearer_token}",
      "Content-Type": "application/json"
    }
    body = {
      # "tweet_id": params[:tweet_id]
      "tweet_id": "#{@tweet.twitter_tweet_id}"
    }

    begin
      response = RestClient.post(url, body.to_json, headers)


      if @like.save
        flash[:notice] = "ツイートID #{@tweet.twitter_tweet_id} にいいねしました！"
      else
        flash[:alert] = "いいねに失敗しました。エラー: #{@like.errors.full_messages.join(', ')}"
        puts "エラー: #{@like.errors.full_messages.join(', ')}"
      end
    rescue RestClient::ExceptionWithResponse => e
      flash[:alert] = "いいねに失敗しました。エラー: #{e.response.body}"
      puts "エラー: #{e.response.body}"
    end
    # リダイレクトする

    redirect_back(fallback_location: root_path)
  end

  def destroy
    # @like = current_user.likes.find_by(tweet_id: @tweet.id)
    @tweet = Tweet.find_by(twitter_tweet_id: params[:tweet_id])
    @like = current_user.likes.find_by(tweet: @tweet)

    if @like
      # bearer_token = current_user.oauth_token
      bearer_token = ENV['BEARER_TOKEN']
      # @like = current_user.likes.find_by(tweet_id: @tweet.id)
      # url = "https://api.twitter.com/2/users/#{current_user.uid}/likes/#{twitter_tweet_id}"

      url = "https://api.twitter.com/2/users/#{current_user.uid}/likes/#{@tweet.twitter_tweet_id}"

      headers = {
        "Authorization": "Bearer #{bearer_token}",
        "Content-Type": "application/json"
      }

      begin
        response = RestClient.delete(url, headers)
        @like.destroy
        flash[:notice] = "ツイートID #{@tweet.twitter_tweet_id} のいいねを取り消しました。"
      rescue RestClient::ExceptionWithResponse => e
        flash[:alert] = "いいねの取り消しに失敗しました。エラー: #{e.response.body}"
        puts "エラー: #{e.response.body}"
      end

    else
      flash[:alert] = "いいねが存在しません。"
    end

    redirect_back(fallback_location: root_path)
  end

  private

  def find_tweet
    @tweet = Tweet.find_by(twitter_tweet_id: params[:tweet_id])
    unless @tweet
      flash[:alert] = "ツイートが存在しません。"
      redirect_back(fallback_location: root_path)
    end
  end
end
