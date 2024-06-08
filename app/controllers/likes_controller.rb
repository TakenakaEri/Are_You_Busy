class LikesController < ApplicationController
  # ユーザーの認証を行う
  before_action :authenticate_user!
  before_action :find_tweet, only: [:create, :destroy]

  # def create


  #   # @tweet = Tweet.find_by(twitter_tweet_id: params[:tweet_id])
  #   # @like = current_user.likes.new(tweet: @tweet)

  #   if current_user.present?
  #     # current_user = User.find(current_user)
  #     puts "Current user: #{current_user.inspect}"

  #     # if current_user.token_expired?
  #     #   current_user.refresh_token!
  #     # end

      
  #     oauth_token = 'dXRZWUFzRU9Qcm5wMUR1bVZVRGxhbVpqU21QV3VuMlRTRUdOLWhGcHMtSlpFOjE3MTc4MjU4MjUxOTU6MToxOmF0OjE'
  #     oauth_token_secret = ''
  #     refresh_token = 'WkhoeGZ4QUhTNzNPNXdQMWhENDk5b1F1cG1NMzdvM0tURFB0TTB1U29Xb3Z4OjE3MTc4MjU4MjUxOTU6MToxOnJ0OjE'
  #     p response

  #     # アクセストークンを取得
  #     # access_token = current_user.fresh_token

  #     url = "https://api.twitter.com/2/users/1687676301979865089/likes"

  #     headers = {
  #       # "Authorization" => "Bearer #{access_token}",
  #       "Content-Type" => "application/json",

  #     }
  #     body = {
  #       "tweet_id" => ''
  #     }
      
  #     response = RestClient.post(url, body.to_json)

  #     p response



  #     # puts "Request URL: #{url}"
  #     # puts "Request Headers: #{headers}"
  #     # puts "Request Body: #{body}"


  #     # begin
  #     #   response = RestClient.post(url, body.to_json, headers)
  
  #     #   if response.code == 200
  
  #     #     if @like.save
  #     #       flash[:notice] = "ツイートID #{@tweet.twitter_tweet_id} にいいねしました！"
  #     #     else
  #     #       flash[:alert] = "いいねに失敗しました。エラー: #{@like&.errors&.full_messages&.join(', ')}"
  #     #       puts "エラー@like&.errors: #{@like&.errors&.full_messages&.join(', ')}"
  #     #     end
  
  #     #   else
  #     #     flash[:alert] = "いいねに失敗しました。エラー: #{response.body}"
  #     #     puts "エラ-response.body: #{response.body}"
  #     #   end
  
  #     # rescue RestClient::ExceptionWithResponse => e
  #     #   flash[:alert] = "いいねに失敗しました。エラー: #{e.response.body}"
  #     #   puts "エラーe.response.body: #{e.response.body}"
  #     # end
  #   else
  #     flash[:alert] = "ユーザーが登録されていません。"
  #   end


  #   # リダイレクトする
  #   redirect_back(fallback_location: root_path)
  # end

  def create
    consumer_key=ENV['API_KEY']
    consumer_secret=ENV['API_SECRET']
    consumer = OAuth::Consumer.new(consumer_key, consumer_secret,
              :site => 'https://api.twitter.com',
              :authorize_path => '/oauth/authenticate',
              # :authorize_path => '/oauth/authorize',
              :debug_output => false)

    url = "https://api.twitter.com/2/users/1687676301979865089/likes"

    headers = {
      "User-Agent": "v2LikeTweetRuby",
      "Content-Type" => "application/json",
    }

    body = {
      "tweet_id" => params[:tweet_id]
    }

    oauth_params = {:consumer => consumer, :token => current_user.oauth_token , :secret => current_user.oauth_token_secret}
    # binding.pry
    response = RestClient.post(url, body.to_json, headers.merge(oauth_params))
  end

  
  def destroy
    @tweet = Tweet.find_by(twitter_tweet_id: params[:tweet_id])
    @like = current_user.likes.find_by(tweet: @tweet)

    if @like
      current_user = User.find(current_user.id)
      access_token = current_user.fresh_token
      # bearer_token = ENV['BEARER_TOKEN']

      url = "https://api.twitter.com/2/users/#{current_user.uid}/likes/#{@tweet.twitter_tweet_id}"

      headers = {
        # "Authorization": "Bearer #{bearer_token}",
        "Authorization": "Bearer #{access_token}",
        "Content-Type": "application/json"
      }

      begin
        response = RestClient.delete(url, headers)

        if response.code == 200
          @like.destroy
          flash[:notice] = "ツイートID #{@tweet.twitter_tweet_id} のいいねを取り消しました。"
        else
          flash[:alert] = "いいねの取り消しに失敗しました。エラー: #{response.body}"
          puts "エラー: #{response.body}"
        end

      rescue RestClient::ExceptionWithResponse => e
        # flash[:alert] = "いいねの取り消しに失敗しました。エラー: #{e.response.body}"
        # puts "エラー: #{e.response.body}"
        puts "API request failed with error: #{e.response.body}"
        raise
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
