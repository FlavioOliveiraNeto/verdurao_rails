class CreateTableAddresses < ActiveRecord::Migration[8.0]
  def change
    create_table :addresses do |t|
      t.string :zip_code
      t.string :street
      t.string :number
      t.string :complement
      t.string :neighborhood
      t.string :city
      t.string :state

      t.timestamps
    end
  end
end
