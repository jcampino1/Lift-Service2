class CreateClientes < ActiveRecord::Migration[5.1]
  def change
    create_table :clientes do |t|
      t.string :nombre
      t.string :contrato
      t.integer :telefono

      t.timestamps
    end
  end
end
