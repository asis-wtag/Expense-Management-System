Rails.application.routes.draw do
  root 'main#index'
  resource :session
  resource :registrations
  resource :password_reset
  resource :password
  resource :confirmation
  get 'organizations/invitations', to: 'organizations#invitations'
  resources :organizations do
    member do
      post 'add_people'
      get 'invite_people'
      get 'add_trading'
      post 'create_trading'
    end
  end

end
