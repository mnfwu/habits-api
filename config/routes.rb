Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :master_habits do
        resources :habits do
          resources :steps, only: [:index, :create, :show, :destroy]
        end
      end
      resources :groups do
        resources :goals, only: [:create, :update, :destroy]
      end
      get 'users/:user_id/groups', to: 'groups#show_user_groups', as: 'show_user_groups'
      get '/users/:user_id/master_habits', to: 'master_habits#show_user_master_habits', as: 'show_user_master_habits'
      post '/login', to: 'login#login'
      put '/login/users/:user_id', to: 'login#update_user'
      put '/steps/:id', to: 'steps#update'
      post '/groups/:group_id/newuser', to: 'groups#add_user_to_group'
      get 'master_habits/:master_habit_id/analytics', to: 'master_habits#analytics'
    end
  end
end
