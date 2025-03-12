class CreateTableUsersAddresses < ActiveRecord::Migration[8.0]
  def change
    create_table :users_addresses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :address, null: false, foreign_key: true
      t.integer :default, null: false, default: 0

      t.timestamps
    end
  end
end
