Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    post 'trackers', to: 'trackers#create'
    get 'trackers', to: 'trackers#index'
    get '/trackers/:gps_id', to: 'trackers#show'
  end
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
