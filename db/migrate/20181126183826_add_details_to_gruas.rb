class AddDetailsToGruas < ActiveRecord::Migration[5.1]
  def change
  	add_column :gruas, :marca, :string
  	add_column :gruas, :modelo, :string
  	add_column :gruas, :serie, :string
  	add_column :gruas, :motor, :string
  	add_column :gruas, :patente, :string
  	add_column :gruas, :ano, :integer
  	add_column :gruas, :ton, :integer
  	add_column :gruas, :mastil, :float
  	add_column :gruas, :observaciones, :text
  end
end
