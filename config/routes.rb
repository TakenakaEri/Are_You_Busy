Rails.application.routes.draw do
  devise_for :users, controllers:
    {
      # Twitter API認証用
      omniauth_callbacks: 'users/omniauth_callbacks',
    }

  # rootをTOPページへ遷移
  root 'staticpages#top'

  # ユーザーIDを返すためのルーティング
  get '/staticpages/get_user_id', to: 'staticpages#get_user_id', as: 'get_user_id'
  # get '/staticpages/get_user_tweets', to: 'staticpages#get_user_tweets', as: 'get_user_tweets'

  # ツイートの取得遷移
  get 'tweets/new'
  # User関連
  resources :users, only: [:new, :create, :edit, :update, :show]

  # ツイート関連
  resources :tweets, only: [:index, :new, :create, :destroy]

  # ブックマーク関連
  resources :bookmarks, only: [:create, :destroy]

  # いいね関連
  # resources :likes, only: [:create, :destroy]
  post '/like_multiple_tweets', to: 'likes#create_multiple'
  post '/like_tweets', to: 'staticpages#like_tweets', as: 'like_tweets'
  post '/tweets/:tweet_id/like', to: 'likes#create', as: 'like_tweet'
  delete '/tweets/:tweet_id/like', to: 'likes#destroy', as: 'unlike_tweet'

  # フォロー関連
  resources :followed_accounts, only: [:create, :destroy]

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

end