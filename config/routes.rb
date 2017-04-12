Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :admin do
    resources :events
    resources :people
    resources :attendances
  end
  resources :invites do
    member do
      patch 'respond_to_return_invite'
      patch 'respond_to_new_invite'
      get 'share'
      get 'rejected'
      get 'confirmed'
    end
  end
  get '/:code', to: 'invites#redirect', as: 'short_invite'
end
