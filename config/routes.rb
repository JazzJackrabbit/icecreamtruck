Rails.application.routes.draw do
  root 'home#index'

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :orders, only: [:show, :index, :create]
      resources :trucks, only: [:show, :index]

      match "*path", to: "api#route_not_found", via: :all
    end
  end

  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
end
