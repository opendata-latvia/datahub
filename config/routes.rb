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
      resources :datasets do
        member do
          put 'delete_columns'
        end
        resources :source_files do
          member do
            put 'start_import'
          end
        end
      end
    end
  end

  match ':login' => 'accounts#show', :as => :account_profile
  match ':account_id/:shortname' => 'projects#show', :as => :project_profile
  match ':account_id/:project_shortname/:shortname' => 'datasets#show', :as => :dataset_profile
  match ':account_id/:project_shortname/:shortname/_datatable' => 'datasets#datatable', :as => :dataset_profile_datatable
  match ':account_id/:project_shortname/:dataset_shortname/_files/:file_name' => 'source_files#download', :as => :dataset_source_file_download
  match ':account_id/:project_shortname/:dataset_shortname/_preview/:file_name' => 'source_files#preview', :as => :dataset_source_file_preview

end
