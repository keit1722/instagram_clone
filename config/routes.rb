Rails.application.routes.draw do
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
