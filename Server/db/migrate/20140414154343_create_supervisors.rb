class CreateSupervisors < ActiveRecord::Migration
  def change
    create_table :supervisors do |t|
      t.string :name
      t.integer :code
      t.integer :organization_id
      t.timestamps
    end
  end
end
