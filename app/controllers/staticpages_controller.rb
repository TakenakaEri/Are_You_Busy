class StaticpagesController < ApplicationController
  
  # ユーザーIDを返すメソッド
  def get_user_id
      username = params[:username]
      bearer_token = ENV['BEARER_TOKEN'] # ここにBearerトークンを入力
      
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

        rescue RestClient::ExceptionWithResponse => e
          puts e.message
          # render json: { error: e.response.body }, status: e.response.code
          @error_message = e.response.body
          end
          # リダイレクト前に@user_idをセッションに保存
          session[:user_id] = @user_id
          redirect_to root_path
        
      end

      def top
        # セッションから@user_idを取得、なければ初期値にnil
        @user_id = session[:user_id]
          # @error_messageはfalse(初期化)
        @error_message = false
      end
end
