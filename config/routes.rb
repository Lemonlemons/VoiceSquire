Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks" }

  resources :quests do
    member do
      get 'getmeaquest'
      get 'dotraining'
      get 'submitproposal'
      get 'submitrevisedproposal'
      get 'revisionthanks'
      post 'paybill'
      get 'submitproof'
      get 'releasepayment'
      get 'paycharge'
      get 'paybillreturn'
      get 'flagquest'
      get 'findquest'
      get 'activeswitch'
      get 'getmyquest'
      get 'moretexts'
      get 'gettextquest'
      get 'moreinfo'
    end
  end

  resources :dukes
  post 'dukes/sign_up_check' => 'dukes#sign_up_check'

  resources :messages
  resources :reviews
  resources :notes

  post 'twilio/voice' => 'twilio#voice'
  post 'twilio/record' => "twilio#record"
  post 'twilio/message' => "twilio#message"
  post 'twilio/connect_customer' => 'twilio#connect_customer'
  post 'twilio/squire_queue' => 'twilio#squire_queue'
  post 'twilio/duke_queue' => 'twilio#duke_queue'
  post 'twilio/squire_hungup' => 'twilio#squire_hungup'
  post 'twilio/duke_hungup' => 'twilio#duke_hungup'
  post 'twilio/squire_connect' => 'twilio#squire_connect'
  post 'twilio/duke_connect' => 'twilio#duke_connect'
  post 'twilio/squire_record' => 'twilio#squire_record'
  post 'twilio/duke_record' => 'twilio#duke_record'
  post 'twilio/squirevoice' => 'twilio#squirevoice'
  post 'twilio/squiremessage' => 'twilio#squiremessage'

  root 'quests#index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
