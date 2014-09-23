TicketManager::Application.routes.draw do
  SSL_PROTO__ = 'https' unless defined?(SSL_PROTO__)

  get "sessions/login"
  get "welcome/new"
  post "sessions/login_attempt"
  get "sessions/logout"
  get "sessions/profile"
  get "sessions/setting"
  get "users/admin_control", as: :admin_control
  get "users/logout"
  
  resources :tickets
  resources :season_tickets do
    collection do
      get "pick_seats"
      get "reserve_seats"
      post "import"
    end
    member do
      get "pick_performances"
    end
  end
  resources :organizations
  resources :productions
  resources :performances
  resources :users do
    member do
      get "admin_edit"
      get "edit_information"
      patch "update_information"
    end
    collection do
      get "part_two"
    end
  end
  resources :transactions do
      get "payment"
      put "update_information"
      get "summary_page"
      put "confirm"
      collection do
        get "list"
        get "pick_seat_numbers"
      end
      member do
        get "purchase_seats"
        get "swap_seats"
        get "swap_performances"
        get "change_seats"
        get "pick_performance"
        get "update_payment"
      end
  end
  
  resources :seasons
  resources :accounts
  resources :supervisors do
    collection do
      get "override"
      put "override_request"
    end
  end
  resources :division_price_points
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'
  get 'accounts/login' => 'accounts#login'
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
