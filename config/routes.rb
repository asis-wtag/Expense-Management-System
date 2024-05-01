Rails.application.routes.draw do
  root 'main#index'
  resource :session, only: %i[new create destroy]
  resource :registrations, only: %i[new create]
  resource :password, only: %i[edit update]
  resource :password_reset, only: %i[new create edit update]
  resource :confirmation, only: %i[new create show]
  get 'organizations/invitations', to: 'organizations#invitations'
  get 'organizations/my_organizations', to: 'organizations#my_organizations'
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  resources :organizations, only: %i[new create shows] do
    member do
      post 'add_people'
      delete 'remove_people'
      get 'invite_people'
      get 'tradings'
      get 'add_trading'
      post 'create_trading'
      delete 'delete_trading'
      get 'search_trading'
      get 'filtered_tradings'
      patch 'accept_invitation'
      patch 'reject_invitation'
      patch 'make_admin'
      post 'add_comment'
      delete 'delete_comment'
      delete 'delete_organization'
    end
  end
  match '*path', to: 'errors#not_found', via: :all
end
