class CreateDivisionPricePoints < ActiveRecord::Migration
  def change
    create_table :division_price_points do |t|
      t.integer :performance_id
      t.integer :division_id
      
      t.decimal :adult_price, precision: 30, scale: 2
      t.decimal :child_price, precision: 30, scale: 2
      t.decimal :military_price, precision: 30, scale: 2
      
      t.timestamps
    end
  end
end
