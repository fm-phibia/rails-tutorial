Rails.application.routes.draw do
  # ルートページの指定
  root "articles#index"

  # GET /articles 
  # These requests are mapped to the index action of 
  # ArticlesController.
  get "/articles", to: "articles#index"

  # /articles/[id] とすることで、showページに遷移させる
  get "/articles/:id", to: "articles#show"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
