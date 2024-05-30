require 'x'

X_CREDENTIALS = {
  api_key: ENV['API_KEY'],
  api_key_secret: ENV['API_SECRET'],
  access_token: ENV['ACCESS_TOKEN'],
  access_token_secret: ENV['ACCESS_TOKEN_SECRET']
}

# X_CLIENT = X::Client.new(**X_CREDENTIALS)