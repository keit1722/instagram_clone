Rails.application.routes.draw do
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  resources :users, only: %i[index new create show]

  # :shallowオプションを指定するとedit・show・update・destroyのアクション（idを必要とするアクション）のエンドポイントとヘルパーメソッドがスッキリする（浅いネスト）
  resources :posts, shallow: true do
    collection { get :search } # postsコントローラーのsearchアクション、エンドポイントは /posts/search
    resources :comments
  end
  resources :likes, only: %i[create destroy]
  resources :relationships, only: %i[create destroy]
  resources :activities, only: [] do # only: に空配列を指定することで /activities/:id/read というエンドポイントのみ作成している
    patch :read, on: :member # member do patch :read end と同じ意味
  end

  # /mypage/account/〜となるようにルーティング設定
  namespace :mypage do
    resource :account, only: %i[edit update]
    resources :activities, only: %i[index]
  end

  root 'posts#index'
end
