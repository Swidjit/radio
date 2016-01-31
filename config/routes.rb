Rails.application.routes.draw do

  devise_for :users,
    :controllers => { :registrations => "registrations", :sessions => "sessions",omniauth_callbacks: 'omniauth_callbacks' }
  resources :users do
    member do
      post 'upload_file'
      get 'favorites'
    end
    resources :playlists, :only => [:show, :create,:destroy] do

    end
  end

  resources :bands, :only => [:show, :index, :update] do
    resources :shows, :only => [:show, :index, :update] do
      collection do
        get 'year/:year' => 'shows#load_shows'
      end
      resources :songs, :only => [:show, :index, :update]
    end

  end

  resources :songs, :only => [:index] do
    post 'reaction'
    get 'load_group'
    collection do
      get 'load' => 'songs#show'
      get 'shuffle'
      get 'radio'
      get 'group/:title' => 'songs#load_group'
    end
  end

  resources :song_groups, :only => [:show] do
    get 'vote'
  end

  resources :shows, :only => [:index] do
    get 'load'
    get 'load_shows', :as => :load_shows
    collection do
      get 'load_random'
    end
    post 'reaction'
  end


  resources :posts, :only => [:create, :update, :destroy, :show,:index, :edit] do
    collection do
      get 'autocomplete_tag_search'
    end
    member do
      post 'create_or_destroy_reaction'
    end
  end
  resources :comments, :only => [:create, :destroy] do
    collection do
      post 'add_from_feed'
    end
  end
  resources :playlists,:only => [:index, :show] do
    member do
      post :add_song_to
    end
    collection do
      post :add_song
    end
  end

  root 'pages#home'
  get '/pages/:page_name' => 'pages#index', :as => :pages
  post '/search/:scope' => 'search#index', :as => :search
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
