class CreateGruas < ActiveRecord::Migration[5.1]
  def change
    create_table :gruas, primary_key: %i[numero_serie] do |t|
    	t.integer :numero_serie
      t.string :tipo
    	t.float :horometro
    	t.string :lugar_actual
    	t.string :cliente
    	t.string :contrato
    	t.string :propietario
    	t.boolean :asegurada
    	t.string :estado
      t.string :mantenciones, array: true, default: []
      t.integer :secuencia
      t.float :horas_faltantes
      t.float :horas_teoricas
      t.string :dicc_mantenciones

      t.timestamps
    end
  end
end
