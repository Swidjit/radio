Rails.application.routes.draw do

  devise_for :users,
    :controllers => { :registrations => "registrations", :sessions => "sessions",omniauth_callbacks: 'omniauth_callbacks' }
  resources :users do
    member do
      post 'upload_file'
    end
  end

  resources :bands, :only => [:show, :index, :update] do
    resources :shows, :only => [:show, :index, :update] do
      collection do
        get 'year/:year' => 'shows#index'
      end
      resources :songs, :only => [:show, :index, :update]
    end

  end

  resources :songs, :only => [] do
    collection do
      get 'load/:filename' => 'songs#show'
      get 'shuffle'
      get 'group/:title' => 'songs#index'
    end
  end

  resources :song_groups, :only => [] do
    get 'vote'
  end

  resources :shows, :only => [] do
    get 'load'
  end


  resources :posts, :only => [:create, :update, :destroy, :show,:index, :edit] do
    collection do
      get 'autocomplete_tag_search'
    end
    member do
      post 'create_or_destroy_reaction'
    end
  end
  resources :comments, :only => [:create, :destroy]

  root 'pages#home'
  get '/pages/:page_name' => 'pages#index', :as => :pages
  get '/posts/:category/:tag' => 'posts#index', :as => :filtered_posts
  get '/sitemap.xml' => 'pages#sitemap'
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
