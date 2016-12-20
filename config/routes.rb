Rails.application.routes.draw do
  scope :api do
    namespace :v1 do
      resources :lists, except: :put
    end
  end
end
