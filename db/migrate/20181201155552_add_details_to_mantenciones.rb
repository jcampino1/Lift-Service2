class AddDetailsToMantenciones < ActiveRecord::Migration[5.1]
  def change
  	add_column :gruas, :necesita, :boolean, default: false
  end
end
