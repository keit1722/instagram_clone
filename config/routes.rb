Rails.application.routes.draw do
  # require_loginメソッドを用意したのでここで条件分岐は不要
  root 'posts#index'

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  resources :users, only: %i[index new create show]

  # :shallowオプションを指定するとedit・show・update・destroyのアクション（idを必要とするアクション）のエンドポイントとヘルパーメソッドがスッキリする（浅いネスト）
  resources :posts, shallow: true do
    resources :comments
  end
  resources :likes, only: %i[create destroy]
  resources :relationships, only: %i[create destroy]
end
