class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.integer :grua_id
      t.integer :numero
      t.string :cliente
      t.date :fecha
      t.time :hora_entrada
      t.time :hora_salida
      t.float :horometro
      t.boolean :preventiva
      t.boolean :correctiva
      t.boolean :dano
      t.string :estado_maquina
      t.text :trabajos_realizados, array: true, default: []
      t.string :repuestos_usados, array: true, default: []
      t.string :equipo
      t.float :total, default: 0
      t.float :horas_hombre
      t.float :costo



      t.timestamps
    end
  end
end
