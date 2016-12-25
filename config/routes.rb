Rails.application.routes.draw do
  scope :api do
    namespace :v1 do
      resources :lists, except: :put do
        resources :tasks, except: :put
      end
    end
  end
end
