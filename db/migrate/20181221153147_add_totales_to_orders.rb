class AddTotalesToOrders < ActiveRecord::Migration[5.1]
  def change
  	add_column :orders, :mano_obra, :float
  	add_column :orders, :total_repuestos, :float
  	add_column :ajustes, :equipo, :string
  end
end
