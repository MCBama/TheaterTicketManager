class AddPricesToProductions < ActiveRecord::Migration
  def change
    add_column :productions, :default_adult, :decimal, precision:30, scale:2
    add_column :productions, :default_child, :decimal, precision:30, scale:2
    add_column :productions, :default_military, :decimal, precision:30, scale:2
    
    add_column :performances, :default_adult, :decimal, precision:30, scale:2
    add_column :performances, :default_child, :decimal, precision:30, scale:2
    add_column :performances, :default_military, :decimal, precision:30, scale:2
  end
end
