# frozen_string_literal: true

Rails.application.routes.draw do
  get '/' => 'home#show', as: :home

  resources :users, only: [:index] do
    collection do
      resources :login, only: [:create] do
        get '/' => :check, on: :collection
      end
      delete '/logoff' => 'login#logoff'
    end
  end

  resources :folders, only: %i[show], path: :browse do
    resources :folders, only: %i[index]
    resources :user_files, only: %i[index show], path: :files do
      member do
        get :download, defaults: { format: :raw }
      end
    end
  end
end
