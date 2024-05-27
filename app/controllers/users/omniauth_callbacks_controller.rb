class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
 
  def twitter
    # Twitterからの認証データを元に、ユーザーをデータベースから検索または新規作成
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user
        # 取得または作成したユーザーをサインイン（ログイン）させ、そのユーザーのホームページにリダイレクト
        sign_in_and_redirect(@user)

    else
        # ユーザーの取得または作成に失敗した場合、アプリケーションのルートページにリダイレクトし、エラーメッセージを表示
        redirect_to root_path, alert: "ユーザーデータの取り扱いに失敗しました"
    end
  end



end
