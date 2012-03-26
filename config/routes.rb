require 'subdomain'

Kassi::Application.routes.draw do


  get "mpesa_sms/index"

  get "payments/home"
  post "payments/home"

  get "payments/all"

  get "payments/new"

  get "payments/show"

  get "payments/confirm"

  resources :sub_categories

  resources :categories

  resources :services

 # get "deliverable/home"

 # get "deliverable/load"

 # get "deliverable/create"

 # get "deliverable/new"

 # get "payment/home"

 # get "payment/check"

 # get "payment/account_exists"

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
  #       get :short
  #       post :toggle
  #     end
  #
  #     collection do
  #       get :sold
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
  #       get :recent, :on => :collection
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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'

  # Adds locale to every url right after the root path
  scope "(/:locale)" do
    devise_for :people, :controllers => { :confirmations => "confirmations" }

    namespace :admin do
      resources :feedbacks
    end
    resources :listings do
      member do
        post :follow
        delete :unfollow
      end
      collection do
        get :more_listings
        get :browse
        get :random
      end
      resources :images, :controller => :listing_images
      resources :comments
    end
    resources :deliverable, :controller =>:deliverable

    resources :people do
      collection do
        get :check_username_availability
        get :check_email_availability
        get :check_email_availability_and_validity
        get :check_invitation_code
        get :not_member
      end
      member do
        put :update_avatar
        put :activate
        put :deactivate
      end
      resources :listings do
        member do
          put :close
        end
      end
      resources :messages, :controller => :conversations do
        collection do
          get :received
          get :sent
          get :notifications
        end
        member do
          put :accept
          put :reject
          put :cancel
        end
        resources :messages
        resources :feedbacks, :controller => :testimonials do
          collection do
            put :skip
          end
        end
      end
      resource :settings do
        member do                                                         def time_ago(from_time, to_time = Time.now)
    from_time = from_time.to_time if from_time.respond_to?(:to_time)
    to_time = to_time.to_time if to_time.respond_to?(:to_time)
    distance_in_minutes = (((to_time - from_time).abs)/60).round
    distance_in_seconds = ((to_time - from_time).abs).round
    case distance_in_minutes
      when 0..1           then time = (distance_in_seconds < 60) ? "#{distance_in_seconds} #{t('timestamps.seconds_ago')}" : "1 #{t('timestamps.minute_ago')}"
      when 2..59          then time = "#{distance_in_minutes} #{t('timestamps.minutes_ago')}"
      when 60..90         then time = "1 #{t('timestamps.hour_ago')}"
      when 90..1440       then time = "#{(distance_in_minutes.to_f / 60.0).round} #{t('timestamps.hours_ago')}"
      when 1440..2160     then time = "1 #{t('timestamps.day_ago')}" # 1-1.5 days
      when 2160..2880     then time = "#{(distance_in_minutes.to_f / 1440.0).round} #{t('timestamps.days_ago')}" # 1.5-2 days
      #else time = from_time.strftime(t('date.formats.default'))
    end
    if distance_in_minutes > 2880
      distance_in_days = (distance_in_minutes/1440.0).round
      case distance_in_days
        when 0..30    then time = "#{distance_in_days} #{t('timestamps.days_ago')}"
        when 31..364  then time = "#{(distance_in_days.to_f / 30.0).round} #{t('timestamps.months_ago')}"
        else               time = "#{(distance_in_days.to_f / 365.24).round} #{t('timestamps.years_ago')}"
      end
    end

    return time
  end
          get :profile
          get :avatar
          get :account
          get :notifications
        end
      end
      resources :invitations
      resources :badges
      resources :testimonials
    end
    resources :infos do
      collection do
        get :about
        get :how_to_use
        get :terms
        get :register_details
      end
    end
    resource :terms do
      member do
        post :accept
      end
    end
    resources :sessions do
      collection do
        post :request_new_password
      end
    end
    resources :consent
    resource :sms do
      get :message_arrived
    end
    resources :contact_requests do
      collection do
        get :thank_you
      end
    end
  end

  # Some non-RESTful mappings
  match '/badges/:style/:id.:format' => "badges#image"
  match "/people/:person_id/inbox/:id", :to => redirect("/fi/people/%{person_id}/messages/%{id}")
  match "/:locale/load" => "listings#load", :as => :load
  match "/:locale/loadmap" => "listings#loadmap", :as => :loadmap
  match "/:locale/offers" => "listings#offers", :as => :offers
  match "/:locale/requests" => "listings#requests", :as => :requests
  match "/:locale/offers/tag/:tag" => "listings#offers", :as => :offers_with_tag
  match "/:locale/requests/tag/:tag" => "listings#requests", :as => :requests_with_tag
  match "/:locale/people/:id/:type" => "people#show", :as => :person_listings
  match "/:locale/people/:person_id/messages/:conversation_type/:id" => "conversations#show", :as => :single_conversation
  match "/:locale/people/:person_id/messages" => "conversations#received", :as => :reply_to_listing
  match "/:locale/listings/:id/reply" => "conversations#new", :as => :reply_to_listing
  match "/:locale/listings/new/:type/:category" => "listings#new", :as => :new_request_category
  match "/:locale/listings/new/:type" => "listings#new", :as => :new_request
  match "/:locale/search" => "search#show", :as => :search
  match "/:locale/logout" => "sessions#destroy", :as => :logout, :method => :delete
  match "/:locale/signup" => "people#new", :as => :sign_up
  match "/:locale/signup/check_captcha" => "people#check_captcha", :as => :check_captcha
  match "/:locale/confirmation_pending" => "sessions#confirmation_pending", :as => :confirmation_pending
  match "/:locale/login" => "sessions#new", :as => :login
  match "/change_locale" => "i18n#change_locale"
  match '/:locale/tag_cloud' => "tag_cloud#index", :as => :tag_cloud
  match "/:locale/offers/map/" => "listings#offers_on_map", :as => :offers_on_map
  match "/:locale/requests/map/" => "listings#requests_on_map", :as => :requests_on_map
  match "/api/query" => "listings#serve_listing_data", :as => :listings_data
  match "/:locale/listing_bubble/:id" => "listings#listing_bubble", :as => :listing_bubble
  match "/:locale/listing_bubble_multiple/:ids" => "listings#listing_bubble_multiple", :as => :listing_bubble_multiple

  # Inside this constraits are the routes that are used when request has subdomain other than www
  #constraints(Subdomain) do
    match '/:locale/' => 'homepage#index'
    match '/' => 'homepage#index'
  #end

  # Below are the routes that are matched if didn't match inside subdomain constraints
  #match '/:locale' => 'dashboard#index'

  root :to => 'homepage#index'

end
