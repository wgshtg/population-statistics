Rails.application.routes.draw do
  root 'home#index'
  get "/statistics", to: "statistics#index"
  get "/statistics/query", to: "statistics#query"
  get "/comparison", to: "comparison#index"
  get "/comparison/compare", to: "comparison#compare"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
