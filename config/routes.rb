Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :master_habits do
        resources :habits do
          resources :steps, only: [:index, :create, :show, :destroy]
        end
      end
      resources :groups
      get 'users/:user_id/groups', to: 'groups#show_user_groups', as: 'show_user_groups'
      get '/users/:user_id/master_habits', to: 'master_habits#show_user_master_habits', as: 'show_user_master_habits'
      post '/login', to: 'login#login'
      patch '/steps/:step_id', to: 'steps#update'
    end
  end
end
