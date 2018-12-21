class AddNumeroGruasToOrders < ActiveRecord::Migration[5.1]
  def change
  	add_column :orders, :numero_gruas, :integer

  end
end
