json.extract! order, :id, :grua_id, :numero, :cliente, :fecha, :hora_entrada, :hora_salida, :horometro, :preventiva, :estado_maquina, :trabajos_realizados, :repuestos_usados, :equipo, :created_at, :updated_at
json.url order_url(order, format: :json)
