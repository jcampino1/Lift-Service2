Rails.application.routes.draw do

  #devise_for :users

  devise_for :users, controllers: {
        sessions: 'users/sessions'
      }


  get 'gruas/revisar_mantenciones', to: 'gruas#revisar_mantenciones',
   as: :revisar_mantenciones
  post 'gruas/analisis', to: 'gruas#analisis', as: :analisis

  get 'gruas/mantencion_realizada', to: 'gruas#mantencion_realizada', as: :mantencion_realizada

  post 'gruas/actualizar_hora_hombre', to: 'gruas#actualizar_hora_hombre', as: :actualizar_hora_hombre
  
  resources :ingresos do
    get 'cerrar', to: "ingresos#cerrar", as: :cerrar
    get 'completar', to: "ingresos#completar", as: :completar
  end

  resources :clientes do
    collection { post :import }
  end

  resources :repuestos do
    collection { post :import }
    post 'actualizar_atributos', to: 'repuestos#actualizar_atributos', as: :actualizar_atributos
  end
  
  resources :gruas do
    collection { post :import }
    post 'actualizar_horometro', to: 'gruas#actualizar_horometro', as: :actualizar_horometro
    post 'actualizar_cliente', to: 'gruas#actualizar_cliente', as: :actualizar_cliente
    post 'calcular_repuestos', to: 'gruas#calcular_repuestos', as: :calcular_repuestos
  	resources :orders
  end

  resources :suppliers do
  	collection { post :import }
  end

  resources :traspasos
  resources :ajustes

  #get 'importar', to: 'gruas#importar', as: :importar

  root "gruas#index"
end
