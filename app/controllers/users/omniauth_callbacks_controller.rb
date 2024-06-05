class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def twitter2
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user
    #取得してきたauthのユーザーの情報をputsで出力
    puts "userの情報"
    puts @user

      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Twitter") if is_navigational_format?
    else
      # request.env["omniauth.auth"]ユーザー情報を取得
      session["devise.twitter2_data"] = request.env["omniauth.auth"].except(:extra)
      # ルート画面にリダイレクト
      redirect_to root_path
    end



  end

  def failure
    # ログインに失敗した場合は、ルート画面にリダイレクト
    redirect_to root_path
  end

end


# def twitter
#   # Twitterからの認証データを元に、ユーザーをデータベースから検索または新規作成
#   @user = User.find_for_oauth(request.env['omniauth.auth'])
#   if @user
#       # 取得または作成したユーザーをサインイン（ログイン）させ、そのユーザーのホームページにリダイレクト
#       sign_in_and_redirect(@user)

#   else
#       # ユーザーの取得または作成に失敗した場合、アプリケーションのルートページにリダイレクトし、エラーメッセージを表示
#       redirect_to root_path, alert: "ユーザーデータの取り扱いに失敗しました"
#   end
# end