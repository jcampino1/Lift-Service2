class CreateRepuestos < ActiveRecord::Migration[5.1]
  def change
    create_table :repuestos do |t|
      t.string :codigo
      t.string :articulo
      t.string :familia
      t.float :panol, default: 0
      t.float :movil1, default: 0
      t.float :movil2, default: 0
      t.float :stock, default: 0
      t.float :stock_minimo, default: 0
      t.float :valor, default: 0

      t.timestamps
    end
  end
end
