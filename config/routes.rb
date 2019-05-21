Rails.application.routes.draw do
  root 'main_pages#home'
  get '/about',   to: 'main_pages#home'
  get '/contact', to: 'main_pages#home'
  namespace :api, format: 'json' do
   resources :tasks, only: [:index, :create, :update]
  end
end
