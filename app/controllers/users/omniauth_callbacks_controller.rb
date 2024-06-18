class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def twitter
    @user = User.from_omniauth(request.env["omniauth.auth"])

    puts "リフレッシュトークン: #{request.env["omniauth.auth"].credentials.refresh_token}"

    if @user
      sign_in @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Twitter") if is_navigational_format?
      redirect_to staticpages_after_login_path
    else
      # request.env["omniauth.auth"]ユーザー情報を取得
      session["devise.twitter2_data"] = request.env["omniauth.auth"].except(:extra)
      #エラーメッセージを表示
      flash[:alert] = "ログインに失敗しました。"
      # ルート画面にリダイレクト
      redirect_to root_path
    end
  end

  def failure
    # ログインに失敗した場合は、ルート画面にリダイレクト
    redirect_to root_path
  end
end