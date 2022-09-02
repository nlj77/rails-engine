Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/merchants/find', to: 'merchants#find'
      get '/items/find_all', to: 'items#find_all'

      resources :merchants, only: [:index, :show] do

        resources :items, only: [:index], module: :merchants
      end
      resources :items do
        resources :merchant, only: [:index], controller: :item_merchants
      end
    end
  end
end
