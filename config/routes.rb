Rails.application.routes.draw do

  get 'gruas/revisar_mantenciones', to: 'gruas#revisar_mantenciones',
   as: :revisar_mantenciones

  get 'gruas/mantencion_realizada', to: 'gruas#mantencion_realizada', as: :mantencion_realizada

  resources :ingresos do
    get 'cerrar', to: "ingresos#cerrar", as: :cerrar
    get 'completar', to: "ingresos#completar", as: :completar
  end

  resources :clientes do
    collection { post :import }
  end

  resources :repuestos do
    collection { post :import }
  end
  
  resources :gruas do
    collection { post :import }
    post 'actualizar_horometro', to: 'gruas#actualizar_horometro', as: :actualizar_horometro
    post 'calcular_repuestos', to: 'gruas#calcular_repuestos', as: :calcular_repuestos
  	resources :orders
  end

  resources :suppliers do
  	collection { post :import }
  end

  #get 'importar', to: 'gruas#importar', as: :importar

  root "gruas#index"
end
