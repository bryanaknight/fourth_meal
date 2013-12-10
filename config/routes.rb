require 'sidekiq/web'
require 'admin_constraint'

Foodfight::Application.routes.draw do
  post "/guest_confirm_purchase" => "orders#guest_confirm_purchase", as: :guest_confirm_purchase
  get "/guest" => "orders#guest_purchase", as: :guest_purchase
  get "dashboard" => "dashboard#index", :as => 'dashboard'
  resources :categories

  root :to => "restaurants#index"

  resources :orders do
    # post 'purchase', :on => :member
    get 'confirmation', :on => :member
  end

  resources :order_items, except: [:edit]
  get ":slug/order/:id/order_items/:item_id", to: "order_items#edit", as: :edit_order_item

  post "log_out" => "sessions#destroy"
  get "log_in" => "sessions#new"
  get "sign_up" => "users#new"


  resources :users
  resources :sessions
  get "/code" => redirect("https://github.com/JonahMoses/dinner_dash")
  resources :item_categories
  resources :items, except: [:index, :show, :new]

  resources :restaurants
  get ":slug", to: "restaurants#show", as: :restaurant_name
  get ":slug/:id", to: "items#show", as: :restaurant_item
  post ":slug/order/:item_id", to: "order_items#create", as: :create_restaurant_order
  get ":slug/order/:id", to: "orders#show", as: :restaurant_order
  post ":slug/orders/:id/purchase", to: "orders#purchase", as: :purchase_order
  get ":slug/items/new", to: "items#new", as: :new_restaurant_item

  mount Sidekiq::Web, at: '/sidekiq', :constraints => AdminConstraint.new

end
