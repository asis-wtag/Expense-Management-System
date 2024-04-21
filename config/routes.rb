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
      get 'invite_people'
      get 'tradings'
      get 'add_trading'
      post 'create_trading'
      get 'delete_trading'
      get 'accept_invitation'
      get 'reject_invitation'
      get 'make_admin'
      post 'add_comment'
      get 'delete_comment'
    end
  end

end
