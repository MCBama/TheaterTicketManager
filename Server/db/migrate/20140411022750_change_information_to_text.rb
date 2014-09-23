class ChangeInformationToText < ActiveRecord::Migration
  def up
    change_column :organizations, :information, :text
  end
  
  def down
    change_column :organizations, :information, :string
  end
end
