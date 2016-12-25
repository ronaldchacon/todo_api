Rails.application.routes.draw do
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
end
