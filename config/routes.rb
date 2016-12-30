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
      resources :users, only: [:show, :create, :update, :destroy]
      resources :confirmations, controller: "users/confirmations", only: :show,
                                param: :confirmation_token
      resources :password_resets, controller: "users/password_resets",
                                  only: [:show, :create, :update],
                                  param: :reset_token
    end
  end
  root to: "v1/lists#index"
end
