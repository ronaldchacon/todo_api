Rails.application.routes.draw do
  scope :api do
    namespace :v1 do
      resources :lists do
        resources :tasks, only: [:index, :create]
      end
      resources :tasks, only: [:show, :update, :destroy] do
        resources :completions, controller: "tasks/completions", only: :update
      end
    end
  end
end
