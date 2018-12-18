class CreateOtros < ActiveRecord::Migration[5.1]
  def change
    create_table :otros do |t|
      t.string :key
      t.float :valor

      t.timestamps
    end
  end
end
