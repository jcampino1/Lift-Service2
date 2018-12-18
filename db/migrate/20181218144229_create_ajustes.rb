class CreateAjustes < ActiveRecord::Migration[5.1]
  def change
    create_table :ajustes do |t|
      t.string :razon
      t.string :sentido
      t.date :fecha
      t.string :repuestos, array:true, default: []

      t.timestamps
    end
  end
end
