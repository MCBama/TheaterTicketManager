class AddDescriptionToProductions < ActiveRecord::Migration
  def change
    add_column :productions, :description, :text
  end
end
