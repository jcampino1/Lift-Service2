class CreateRepuestos < ActiveRecord::Migration[5.1]
  def change
    create_table :repuestos, primary_key: %i[codigo] do |t|
      t.integer :codigo
      t.string :articulo
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
