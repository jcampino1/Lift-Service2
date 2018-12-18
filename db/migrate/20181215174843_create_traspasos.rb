class CreateTraspasos < ActiveRecord::Migration[5.1]
  def change
    create_table :traspasos do |t|
      t.string :desde
      t.string :hacia
      t.date :fecha
      t.string :repuestos, array: true, default: []

      t.timestamps
    end
  end
end
