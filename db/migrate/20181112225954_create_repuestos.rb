class CreateRepuestos < ActiveRecord::Migration[5.1]
  def change
    create_table :repuestos do |t|
      t.integer :codigo
      t.string :articulo
      t.float :panol
      t.float :movil1
      t.float :movil2
      t.float :stock
      t.float :stock_minimo
      t.float :valor

      t.timestamps
    end
  end
end
