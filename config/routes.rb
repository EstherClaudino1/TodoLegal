Rails.application.routes.draw do
  use_doorkeeper
  resources :documents
  resources :user_permissions
  resources :permissions
  resources :law_modifications
  devise_for :users, controllers: { confirmations: 'users/confirmations', registrations: "users/registrations", sessions: "users/sessions", passwords: "users/passwords" }
  get "/token_login/:authentication_token" => "home#token_login", as: "token_login"
  resources :law_tags
  resources :document_tags
  resources :tags
  resources :tag_types
  resources :laws
  resources :titles, only: [:edit, :update]
  resources :books, only: [:edit, :update]
  resources :chapters, only: [:edit, :update]
  resources :sections, only: [:edit, :update]
  resources :subsections, only: [:edit, :update]
  resources :articles, only: [:edit, :update]

  root :to => "home#index"
  get '/search_law', to: 'home#search_law'
  get '/pricing', to: 'home#pricing'
  get '/invite_friends', to: 'home#invite_friends'
  get '/covid', to: 'home#google_drive_covid_search', as: "google_drive_covid_search"
  get '/drive_search', to: 'home#google_drive_covid_search', as: "drive_search"
  get '/refer', to: 'home#refer', as: "refer"
  get '/crash_tester', to: 'home#crash_tester', as: "crash_tester"
  get '/maintenance', to: 'home#maintenance', as: "maintenance"
  get '/checkout', to: 'billing#checkout', as: "checkout"
  post "/charge" => "billing#charge", as: "charge"
  post "/create_customer_portal_session" => "billing#create_customer_portal_session", as: "create_customer_portal_session"

  get "admin/users" => "admin#users", as: "admin_users"
  post "admin/grant_permission" => "admin#grant_permission", as: "admin_grant_permission"
  post "admin/revoke_permission" => "admin#revoke_permission", as: "admin_revoke_permission"
  post "admin/set_law_access" => "admin#set_law_access", as: "admin_set_law_access"
  get 'admin/enable_edit_mode', to: 'admin#enable_edit_mode', as: "enable_edit_mode"
  get 'admin/disable_edit_mode', to: 'admin#disable_edit_mode', as: "disable_edit_mode"
  get 'admin/gazettes', to: 'admin#gazettes', as: "gazettes"
  get 'admin/gazettes/:publication_number', to: 'admin#gazette', as: "gazette"
  get "signed_in" => "home#index", as: "signed_in"
  get "signed_up" => "home#index", as: "signed_up"
  get "signed_out" => "home#index", as: "signed_out"
  get "download_contributor_users" => "admin#download_contributor_users", as: "download_contributor_users"
  get "download_recieve_information_users" => "admin#download_recieve_information_users", as: "download_recieve_information_users"
  get "download_all_users" => "admin#download_all_users", as: "download_all_users"
  get '/gacetas', to: redirect('https://valid.todolegal.app'), as: "google_drive_search"

  get '/rails/active_storage/blobs/redirect/:signed_id/*filename', to: 'active_storage_redirect#show'

  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      devise_for :users, controllers: { registrations: 'api/v1/registrations', sessions: 'api/v1/sessions' }
      devise_scope :user do
        get "/me", to: 'sessions#me'
      end
      resource :examples do
        member do
          get :action_test
        end
      end
      resource :documents do
        member do
          get "/:id", to: 'documents#get_document'
          get "/", to: 'documents#get_documents'
        end
      end
      resource :laws do
        member do
          get "/:id", to: 'laws#get_law'
        end
      end
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
