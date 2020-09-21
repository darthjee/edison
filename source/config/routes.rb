# frozen_string_literal: true

Rails.application.routes.draw do
  get '/' => 'home#show', as: :home

  resources :users, only: [:index] do
    resources :measurements, only: %i[index create new]

    collection do
      resources :login, only: [:create] do
        get '/' => :check, on: :collection
      end
      delete '/logoff' => 'login#logoff'
    end
  end
end
