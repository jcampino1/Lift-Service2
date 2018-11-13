Rails.application.routes.draw do
  resources :ingresos
  resources :clientes
  resources :repuestos
  resources :gruas do
  	resources :orders
  end

  resources :suppliers

  root "gruas#index"
end
