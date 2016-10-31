class AddNameToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :name, :string
    add_column :users, :address, :string
    add_column :users, :tel, :integer
    add_column :users, :website, :string
    add_column :users, :category, :string
    add_column :users, :about, :string
    add_column :users, :mission, :string
    add_column :users, :avatar, :string
  end
end
