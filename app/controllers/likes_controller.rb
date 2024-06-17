class LikesController < ApplicationController
  require 'oauth/request_proxy/typhoeus_request'
  # ユーザーの認証を行う
  before_action :authenticate_user!
  before_action :find_tweet, only: [:create, :destroy]

  def create
    consumer_key = ENV['CONSUMER_KEY']
    consumer_secret = ENV['CONSUMER_SECRET']
    access_token = ENV['ACCESS_TOKEN']
    access_token_secret = ENV['ACCESS_TOKEN_SECRET']
    id = current_user.uid
    likes_url = "https://api.twitter.com/2/users/#{id}/likes"
    @tweet_id = { "tweet_id": @tweet.twitter_tweet_id }
    consumer = consumer(consumer_key, consumer_secret)
    access_token = obtain_access_token(consumer)
    oauth_params = {:consumer => consumer, :token => access_token}
    response = user_like(likes_url, oauth_params, @tweet_id)
    puts response.code, JSON.pretty_generate(JSON.parse(response.body))
  end
  
  def destroy
  end

  def create_multiple
    tweet_ids = params[:tweet_ids].split(' ')
    consumer_key = ENV['CONSUMER_KEY']
    consumer_secret = ENV['CONSUMER_SECRET']
    consumer = consumer(consumer_key, consumer_secret)
    access_token = obtain_access_token(consumer)
    oauth_params = {:consumer => consumer, :token => access_token}
  
    liked_tweet_ids = []
    tweet_ids.each do |tweet_id|
      likes_url = "https://api.twitter.com/2/users/#{current_user.uid}/likes"
      tweet_id_param = { "tweet_id": tweet_id }
      response = user_like(likes_url, oauth_params, tweet_id_param)
      puts response.code, JSON.pretty_generate(JSON.parse(response.body))
      liked_tweet_ids << tweet_id if response.code == 200
    end
  
    session[:liked_tweet_ids] = liked_tweet_ids
    redirect_to root_path
  end

  private

  def user_like(url, oauth_params, tweet_id_param)
    options = {
      :method => :post,
      headers: {
        "User-Agent": "v2LikeTweetRuby",
        "content-type": "application/json"
      },
      body: JSON.dump(tweet_id_param)
    }
    request = Typhoeus::Request.new(url, options)
    oauth_helper = OAuth::Client::Helper.new(request, oauth_params.merge(:request_uri => url))
    request.options[:headers].merge!({"Authorization" => oauth_helper.header})
    response = request.run
  end

  def consumer(consumer_key, consumer_secret)
    OAuth::Consumer.new(consumer_key, consumer_secret,
    :site => 'https://api.twitter.com',
    :authorize_path => '/oauth/authenticate',
    :debug_output => false)
  end
    
  def obtain_access_token(consumer)
    access_token = OAuth::AccessToken.new(
      consumer,
      current_user.oauth_token,
      current_user.oauth_token_secret
    )
    return access_token
  end

  def find_tweet
    @tweet = Tweet.find_by(twitter_tweet_id: params[:tweet_id])
    unless @tweet
      flash[:alert] = "ツイートが存在しません。"
      redirect_back(fallback_location: root_path)
    end
  end
end