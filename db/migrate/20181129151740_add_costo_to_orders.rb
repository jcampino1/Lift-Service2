class AddCostoToOrders < ActiveRecord::Migration[5.1]
  def change
  	add_column :orders, :costo, :float
  end
end
