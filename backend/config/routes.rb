Rails.application.routes.draw do
  mount ActiveStorage::Engine => "/rails/active_storage"

  namespace :api do
    resources :ebooks, only: %i[index create show destroy] do
      collection do
        get :search
      end

      member do
        get :download
      end
    end
  end
end
