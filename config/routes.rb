Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :master_habits do
        resources :habits do
          resources :steps
        end
      end
    end
  end
end
