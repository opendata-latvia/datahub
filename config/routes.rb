Datahub::Application.routes.draw do

  root :to => "home#index"

  as :user do
    delete "/unregister_omniauth/:id", :to => "users/omniauth_callbacks#destroy", :as => "unregister_omniauth"
  end

  devise_for :users, :controllers => {
    :omniauth_callbacks => "users/omniauth_callbacks",
    :registrations => 'users/registrations'
  }

  resources :accounts do
    resources :projects do
      resources :datasets
    end
  end

  match ':login' => 'accounts#show', :as => :account_profile
  match ':account_id/:shortname' => 'projects#show', :as => :project_profile
  match ':account_id/:project_shortname/:shortname' => 'datasets#show', :as => :dataset_profile


end
