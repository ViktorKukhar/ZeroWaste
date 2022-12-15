# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  #   authenticate :user do
  #     mount Sidekiq::Web => 'admins/sidekiq'
  #   end

  mount Sidekiq::Web => '/sidekiq'

  devise_for :users, only: :omniauth_callbacks,
                     controllers: { omniauth_callbacks:
                     'users/omniauth_callbacks' }

  get '/', to: 'application#redirection', as: :root_redirection

  scope '/(:locale)', locale: /uk|en/ do
    devise_for :users, controllers: { registrations: 'users/registrations' },
                       skip: :omniauth_callbacks

    root 'home#index'

    get '/calculator', to: 'calculators#calculator'
    post '/receive_recomendations', to: 'calculators#receive_recomendations'
    get '/about_us', to: redirect('/about_us.html')

    resources :calculators, only: %i[index show], param: :slug do
      member do
        post :calculate
      end
    end
    resources :messages, only: %i[new create]
    namespace :admins do
      resources :users, only: %i[index show edit update]
      resources :calculators, param: :slug
      resources :histories, only: :index
      resources :messages, only: %i[index show]
      resource :app_config, only: %i[edit update]

      scope module: :calculators do
        resources :calculators, only: [], param: :slug do
          resources :fields, only: :new
        end
      end
    end

    namespace :api do
      namespace :v1 do
        resources :calculators, only: [] do
          post :compute, on: :member
        end
        post '/diaper_calculators',
             to: 'diaper_calculators#diaper_calc_communicator'
      end
      namespace :v2 do
        resources :calculators, only: [] do
          post :compute, on: :member
        end
      end
    end
  end
end
