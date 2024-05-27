class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    has_many :tweets
    has_many :bookmarks
    has_many :likes
    has_many :followed_accounts

    devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable,
    # Twitter API認証用に追加
    :omniauthable, omniauth_providers: [:twitter]

    # Twitter認証ログイン用
    # ユーザーの情報があれば探し、無ければ作成する
    def self.find_for_oauth(auth)
        user = User.find_by(uid: auth.uid, provider: auth.provider)

        user ||= User.create!(
            uid: auth.uid,
            provider: auth.provider,
            name: auth[:info][:name],
            email: User.dummy_email(auth),
            password: Devise.friendly_token[0, 20]
        )

        user
    end

    # ダミーのメールアドレスを作成
    def self.dummy_email(auth)
        "#{Time.now.strftime('%Y%m%d%H%M%S').to_i}-#{auth.uid}-#{auth.provider}@example.com"
    end

    def destroy
        session[:user_id] = nil
        redirect_to root_path, notice: "ログアウトしました"
    end

    private

    def self.user_params
        params.require(:user).permit(:provider, :uid)
    end

end
