class AddHoraInicialToGruas < ActiveRecord::Migration[5.1]
  def change
  	add_column :gruas, :horometro_inicial, :float, default: 0
  end
end
