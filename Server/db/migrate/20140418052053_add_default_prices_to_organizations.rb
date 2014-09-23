class AddDefaultPricesToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :default_adult, :decimal, precision: 30, scale: 2
    add_column :organizations, :default_child, :decimal, precision: 30, scale: 2
    add_column :organizations, :default_military, :decimal, precision: 30, scale: 2
  end
end
