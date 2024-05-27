Rails.application.routes.draw do
  devise_for :users, controllers:
    {
      # Twitter API認証用
      omniauth_callbacks: 'users/omniauth_callbacks'
    }
  # rootをTOPページへ遷移
  root 'staticpages#top'

  # User関連
  resources :users, only: [:new, :create, :edit, :update]

  # セッション関連
  get 'login', to: 'sessions#new'
  delete 'logout', to: 'devise/sessions#destroy'
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')

  # ツイート関連
  resources :tweets, only: [:create, :destroy]

  # ブックマーク関連
  resources :bookmarks, only: [:create, :destroy]

  # いいね関連
  resources :likes, only: [:create, :destroy]

  # フォロー関連
  resources :followed_accounts, only: [:create, :destroy]

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

end
