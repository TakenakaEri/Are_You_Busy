class LikesController < ApplicationController
  require 'oauth/request_proxy/typhoeus_request'
  # ユーザーの認証を行う
  before_action :authenticate_user!
  before_action :find_tweet, only: [:create, :destroy]

  def create
    puts "Current user UID: #{current_user.uid}"
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
    response = user_like(likes_url, oauth_params)
    puts response.code, JSON.pretty_generate(JSON.parse(response.body))
  end
  
  def destroy
  end

  private

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
  
  
  def user_like(url, oauth_params)
  	options = {
  	    :method => :post,
  	    headers: {
  	     	"User-Agent": "v2LikeTweetRuby",
          "content-type": "application/json"
  	    },
  	    body: JSON.dump(@tweet_id)
  	}
  	request = Typhoeus::Request.new(url, options)
  	oauth_helper = OAuth::Client::Helper.new(request, oauth_params.merge(:request_uri => url))
  	request.options[:headers].merge!({"Authorization" => oauth_helper.header})
  	response = request.run
  end

  def find_tweet
    @tweet = Tweet.find_by(twitter_tweet_id: params[:tweet_id])
    unless @tweet
      flash[:alert] = "ツイートが存在しません。"
      redirect_back(fallback_location: root_path)
    end
  end

# 追加
  def create_multiple
    tweet_ids = params[:tweet_ids]
    tweet_ids.each do |tweet_id|
      tweet = Tweet.find_by(twitter_tweet_id: tweet_id)
      if tweet.present? && !current_user.likes.exists?(tweet_id: tweet.id)
        current_user.likes.create(tweet_id: tweet.id)
      end
    end
    redirect_back(fallback_location: root_path)
  end

end