Rails.application.routes.draw do
  namespace :api do
    resources :customers, only: [:create, :show, :index]
  end
end
