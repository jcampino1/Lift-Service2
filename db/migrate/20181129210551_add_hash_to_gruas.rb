class AddHashToGruas < ActiveRecord::Migration[5.1]
  def change
  	add_column :gruas, :dicc_mantenciones, :string
  end
end
