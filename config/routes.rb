Rails.application.routes.draw do
  # require_loginメソッドを用意したのでここで条件分岐は不要
  root 'posts#index'

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  
  resources :users, only: %i[new create]
  resources :posts
end
