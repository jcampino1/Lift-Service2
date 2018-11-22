class CreateIngresos < ActiveRecord::Migration[5.1]
  def change
    create_table :ingresos do |t|
      t.string :proveedor
      t.string :repuestos, array: true, default: []
      t.float :total
      t.date :fecha
      t.integer :numero_factura

      t.timestamps
    end
  end
end
