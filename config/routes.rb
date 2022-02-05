Rails.application.routes.draw do
  root 'home#index'

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      mount_devise_token_auth_for 'Merchant', at: 'auth', controllers: { 
        registrations: 'api/v1/devise/merchant_registrations',
        sessions: 'api/v1/devise/merchant_sessions',
      }
      
      resources :product_categories, path: :categories, except: [:new, :edit]
      resources :products, except: [:new, :edit]
      resources :trucks, except: [:new, :edit] do
        resources :orders, only: [:index, :create]
        
        get '/inventory', to: 'product_inventories#index'
        put '/inventory', to: 'product_inventories#update'
        delete '/inventory', to: 'product_inventories#destroy'
      end
      get '/orders/:id', to: 'orders#show'

      match "*path", to: "api#route_not_found", via: :all
    end
  end

  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
end
