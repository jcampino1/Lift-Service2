class CreateGruas < ActiveRecord::Migration[5.1]
  def change
    create_table :gruas do |t|
    	t.string :tipo
    	t.float :numero_serie
    	t.float :horometro
    	t.string :lugar_actual
    	t.string :cliente
    	t.string :contrato
    	t.string :propietario
    	t.boolean :asegurada
    	t.string :estado

      t.timestamps
    end
  end
end
