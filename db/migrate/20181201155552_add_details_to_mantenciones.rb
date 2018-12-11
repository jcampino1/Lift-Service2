class AddDetailsToMantenciones < ActiveRecord::Migration[5.1]
  def change
  	add_column :gruas, :necesita, :boolean, default: false
  	add_column :gruas, :dicc_a_realizar, :string
  end
end
