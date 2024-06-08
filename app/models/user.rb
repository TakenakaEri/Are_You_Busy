class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :tweets, dependent: :destroy
  has_many :bookmarks
  has_many :likes, dependent: :destroy
  has_many :followed_accounts

  validates :uid, presence: true, uniqueness: true

  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable,
  # Twitter API認証用に追加
  :omniauthable, omniauth_providers: [:twitter2]

  # Twitter認証ログイン用
  # providerとuidをキーにユーザーを検索し、存在しない場合は新しいユーザーを作成。ユーザーのメールアドレス、パスワード、名前、OAuthトークン、リフレッシュトークン、有効期限を設定
  def self.from_omniauth(auth)
    # puts "Auth object: #{auth.inspect}"
    # first_or_create メソッドで作成OR更新を行う
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        # auth.info.emailがある場合はそれを使用し、ない場合はダミーのメールアドレスを生成
        user.email = auth.info.email.presence || "#{auth.uid}-#{auth.provider}@example.com"
        user.password = Devise.friendly_token[0, 20]
        user.name = auth.info.name
        # OAuthトークン
        user.oauth_token = auth.credentials.token
        # リフレッシュトークン
        user.refresh_token = auth.credentials.refresh_token
        # ログに出力
        puts "////Refresh token in from_omniauth: #{user.refresh_token}"
        user.oauth_token_secret = auth.credentials.secret
        # Twitterから取得した認証情報（auth）に含まれるトークンの有効期限 エポックタイムをRubyのTimeオブジェクトに変換
        user.expires_at = Time.at(auth.credentials.expires_at) if auth.credentials.expires_at
      end
  end
  
  # 現在のトークンが有効期限切れかどうかを確認し、有効期限切れの場合は新しいトークンを取得
  def fresh_token
    if token_expired?
      refresh_token!
    else
      oauth_token
    end
  end
  
  # トークンの有効期限が現在の時間よりも前（つまり、有効期限切れ）かどうかを確認
  def token_expired?
    expires_at < Time.current
  end
  
  # 新しいトークンを取得するためにTwitterのAPIにリクエストを送る。新しいトークンとリフレッシュトークン、有効期限を取得したら、それらをデータベースに保存。
  def refresh_token!
    puts "Refreshing token..."
    puts "Refresh token: #{refresh_token}"
    puts "API Key: #{ENV['API_KEY']}"
    puts "API Secret: #{ENV['API_SECRET']}"

    response = RestClient.post('https://api.twitter.com/2/oauth2/token', {
      grant_type: 'refresh_token',
      refresh_token: refresh_token,
      client_id: ENV['API_KEY'],
      # client_secret: ENV['API_SECRET']
      }, {
        'Content-Type' => 'application/x-www-form-urlencoded'
    })

    puts "Response: #{response.body}"

    # data = JSON.parse(response.body)
    # update(
    #   oauth_token: data['access_token'],
    #   refresh_token: data['refresh_token'] || refresh_token,
    #   expires_at: Time.now + data['expires_in'].to_i.seconds
    # )

    if response.code == 200
      data = JSON.parse(response.body)
      update(
        oauth_token: data['access_token'],
        expires_at: Time.current + data['expires_in'].to_i.seconds
      )
      oauth_token
    else
      raise "Failed to refresh token: #{response.body}"
    end
  end
end
