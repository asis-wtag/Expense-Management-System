Rails.application.routes.draw do
  root 'main#index'
  resource :session
  resource :registrations
  resource :password_reset
  resource :password
  resource :confirmation
  resources :organizations do
    member do
      get 'add_people'
    end
  end
end
