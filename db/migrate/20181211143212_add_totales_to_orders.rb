class AddTotalesToOrders < ActiveRecord::Migration[5.1]
  def change
  	add_column :orders, :total_ls, :float, default: 0
  	add_column :orders, :total_cliente, :float, default: 0
  end
end
