class CreateProductions < ActiveRecord::Migration
  def change
    create_table :productions do |t|
      t.belongs_to :organization
      t.timestamps
    end
  end
end
