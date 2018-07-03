Rails.application.routes.draw do
  root 'home#index'
  get "/statistics", to: "statistics#index"
  get "/statistics/query", to: "statistics#query"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
