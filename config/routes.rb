Rails.application.routes.draw do
  devise_for :users
  scope :api do
    namespace :v1 do
      resources :lists do
        resources :tasks, only: [:index, :create]
      end
      resources :tasks, only: [:show, :update, :destroy] do
        patch "/complete", to: "tasks/completions#complete"
        patch "/uncomplete", to: "tasks/completions#uncomplete"
      end
    end
  end
  root to: "v1/lists#index"
end
