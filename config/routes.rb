Dropsocial::Application.routes.draw do

  get  "twilio_callback/index"
  post "twilio_callback/index"
  get  "twilio_callback/receive_voice_recording"
  get  "twilio_callback/receive_transcription"  
  post  "twilio_callback/receive_transcription"  

  # get "comments/create"
  # 
  # get "comments/update"
  # 
  # get "comments/destroy"

  # get "friends/index"
  # 
  # get "friends/invite"

  get "users/index"

  get "users/invite_friends"

  get "users/edit"

  get "users/update"

  get "users/destroy"

  get "authentications/index"

  get "authentications/create"

  get "authentications/destroy"

  get "home/index"
  match "/invite_facebook_sign_up" => "home#invite_facebook_sign_up"

  devise_for :admins
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :users do
    collection do
      put :confirm_primary_email
      get :social_calendar
      
      post :authenticate
    end
  end

  resources :friends do
    collection do 
      get   :invite
      post  :invite
    end
  end

  resources :events do
    collection do
      get :social_calendar
    end
    
    member do
      post :update_rsvp
      get  :export_to_calendar
      get  :summary
    end
    
    resources :comments do
      #
    end
    
    resources :interviews #, :only => [:show]
    
  end
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "home#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
