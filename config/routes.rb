Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :dummy_api do
    collection do
      post :generate_load
    end
  end

  mount Lowkiq::Web => '/lowkiq'

end
