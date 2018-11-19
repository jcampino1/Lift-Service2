class CreateSuppliers < ActiveRecord::Migration[5.1]
  def change
    create_table :suppliers do |t|
      t.string :nombre
      t.integer :codigo
      t.string :categoria
      t.string :correo
      t.integer :telefono
      t.string :direccion
      t.boolean :credito

      t.timestamps
    end
  end
end
