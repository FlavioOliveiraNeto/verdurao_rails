class CreateTableOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.string :telephone, null: false
      t.string :zip_code, null: false
      t.string :street, null: false
      t.string :number, null: false
      t.string :complement, null: false
      t.string :neighborhood, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.integer :quantity, null: false
      t.float :total_price, null: false
      t.integer :situation, null: false, default: 1

      t.timestamps
    end
  end
end
