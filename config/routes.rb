Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :master_habits do
        resources :habits do
          resources :steps
        end
      end
      resources :groups
      get 'users/:user_id/groups', to: 'groups#show_user_groups', as: 'show_user_groups'
      get '/users/:user_id/master_habits', to: 'master_habits#show_user_master_habits', as: 'show_user_master_habits'
      post '/login', to: 'login#login'
      # get '/master_habits/:master_habit_id/allhabits', to: 'habits#show_master_habit_habits', as: 'show_master_habit_habits'
      # get '/habits/:habit_id/steps', to: 'steps#show_habit_steps', as: 'show_habit_steps'
      #last two can be simplified into 'show' views on master habits and habits
    end
  end
end
