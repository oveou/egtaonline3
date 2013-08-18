Egtaonline3::Application.routes.draw do
  resources :users, only: [:index, :update]
  devise_for :users, :controllers => { :registrations => "registrations" }

  namespace :api do
    namespace :v3 do
      resources :generic_schedulers, except: ["new", "edit"] do
        member do
          post :add_profile, :remove_profile, :add_role, :remove_role
        end
      end
      resources :simulators, :games, only: [:show, :index] do
        member do
          post :add_strategy, :remove_strategy, :add_role, :remove_role
        end
      end
      resources :profiles, only: :show
      resources :schedulers, only: :show
    end
  end

  resources :simulators do
    resources :roles, only: [:create, :destroy] do
      resources :strategies, only: [:create, :destroy]
    end
  end

  resources :games do
    resources :roles, only: [:create, :destroy] do
      resources :strategies, only: [:create, :destroy]
    end
    collection do
      post :update_configuration
    end
  end

  resources :schedulers do
    collection do
      post :update_configuration
    end
    member do
      post :create_game_to_match
    end
    resources :roles, only: [:create, :destroy] do
      resources :strategies, only: [:create, :destroy]
      resources :deviating_strategies, only: [:create, :destroy]
    end
  end

  resources :game_schedulers, :hierarchical_schedulers, :dpr_schedulers,
    :deviation_schedulers, :hierarchical_deviation_schedulers,
    :dpr_deviation_schedulers, :generic_schedulers, except: :delete

  resources :profiles, only: :show
  resources :simulations, only: [:index, :show]


  resources :connection, only: [:new, :create]
  root to: 'high_voltage/pages#show', id: 'home'

  require 'sidekiq/web'
  authenticate :user do
    mount Sidekiq::Web, at: "/background_workers"
  end
end
