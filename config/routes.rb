Rails.application.routes.draw do
  devise_for :users, skip: :registrations, path: 'u'
  devise_scope :user do
    resource :registration,
      only: [:new, :create, :edit, :update],
      path: 'u',
      path_names: { new: 'sign_up' },
      controller: 'devise/registrations',
      as: :user_registration do
        get :cancel
    end
  end

  root 'posts#index'

  resources :posts do
    resources :comments, except: [ :show ]
  end

  resources :users, except: [ :new, :create, :show ]
end
