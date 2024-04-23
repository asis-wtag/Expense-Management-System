Rails.application.routes.draw do
  root 'main#index'
  resource :session
  resource :registrations
  resource :password_reset
  resource :password
  resource :confirmation
  get 'organizations/invitations', to: 'organizations#invitations'
  get 'organizations/my_organizations', to: 'organizations#my_organizations'
  resources :organizations do
    member do
      post 'add_people'
      delete 'remove_people'
      get 'invite_people'
      get 'tradings'
      get 'add_trading'
      post 'create_trading'
      delete 'delete_trading'
      patch 'accept_invitation'
      patch 'reject_invitation'
      patch 'make_admin'
      post 'add_comment'
      delete 'delete_comment'
      delete 'delete_organization'
    end
  end

end
