Rails.application.routes.draw do
  resources :ingresos

  resources :clientes do
    collection { post :import }
  end

  resources :repuestos do
    collection { post :import }
  end
  
  resources :gruas do
    collection { post :import }
  	resources :orders
  end

  resources :suppliers do
  	collection { post :import }
  end

  #get 'importar', to: 'gruas#importar', as: :importar

  root "gruas#index"
end
