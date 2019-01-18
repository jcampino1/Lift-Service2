class AddTallerToInventario < ActiveRecord::Migration[5.1]
  def change
  	add_column :repuestos, :taller, :float, default: 0
  end
end
