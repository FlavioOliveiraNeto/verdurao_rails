class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :price
      t.text :description
      t.string :image
      t.integer :stock_quantity

      t.timestamps
    end
  end
end
