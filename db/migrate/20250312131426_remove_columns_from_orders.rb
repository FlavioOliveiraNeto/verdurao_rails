class RemoveColumnsFromOrders < ActiveRecord::Migration[8.0]
  def change
    remove_column :orders, :telephone, :string
    remove_column :orders, :zip_code, :string
    remove_column :orders, :address, :string
    remove_column :orders, :number, :string
    remove_column :orders, :complement, :string
    remove_column :orders, :neighborhood, :string
    remove_column :orders, :city, :string
    remove_column :orders, :state, :string
  end
end
