Rails.application.routes.draw do
  namespace :api, defaults: {format: :json} do
    post "trackers", to: "trackers#create"
    get "trackers", to: "trackers#index"
    get "/trackers/:gps_id", to: "trackers#show"
    resources :trackers do
      post "points", to: "points#create"
      get "points", to: "points#index"
    end
    post "reset_db", to: "debug#reset_db"
  end
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
