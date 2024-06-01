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
          response = RestClient.get(url, headers)
          user_data = JSON.parse(response.body)
          @user_id = user_data["data"]["id"]
          puts "user_id: #{@user_id}"
          #json形式で返ってくる設定コード
          # render json: { user_id: @user_id }

          # ユーザーの最新の10件のツイートを取得
          tweets_url = "https://api.twitter.com/2/users/#{@user_id}/tweets"
          tweets_response = RestClient.get(tweets_url, headers)
          tweets_data = JSON.parse(tweets_response.body)
          @tweets = tweets_data["data"]

          if @tweets.present?
            puts "Tweets data:"
            puts @tweets.inspect
          else
            puts "No tweets data available"
          end

        rescue RestClient::ExceptionWithResponse => e
          puts e.message
          # render json: { error: e.response.body }, status: e.response.code
          @error_message = e.response.body
        end
          # リダイレクト前に@user_idをセッションに保存
          session[:user_id] = @user_id
          # session[:tweets] = @tweets

          # redirect_to root_path
          render 'top'
      end

      def top
        # セッションから@user_idを取得、なければ初期値にnil
        # @user_id = session[:user_id]
        # @tweets = session[:tweets]
          # @error_messageはfalse(初期化)
        # @error_message = false
      end
    end