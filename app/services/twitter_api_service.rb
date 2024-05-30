# app/services/twitter_api_service.rb
require 'httparty'
require 'addressable/uri'
require "cgi"
require "erb"
include ERB::Util

# require 'net/http'
# require 'uri'
# require 'json'

module TwitterApiService
  include HTTParty

  base_uri 'https://api.twitter.com'
  headers 'Authorization' => "Bearer #{ENV['TWITTER_BEARER_TOKEN']}",
          'Content-Type' => 'application/json'

    uri_adapter Addressable::URI

    def self.get_user_id(username)
        encoded_username = Addressable::URI.encode_component(username, Addressable::URI::CharacterClasses::UNRESERVED)
        response = get("/2/users/by/username/#{encoded_username}")
        response.parsed_response.dig('data', 'id') || response.parsed_response['data']['id']
    end

  def self.get_user_tweets(user_id, max_results = 10)
    params = {
      max_results: max_results,
      'tweet.fields' => 'text,created_at'
    }
    response = get("/2/users/#{user_id}/tweets", query: params)
    response.parsed_response.dig('data')
  end
end