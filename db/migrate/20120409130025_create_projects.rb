class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.integer :account_id, :null => false
      t.string :shortname, :limit => 40, :null => false
      t.string :name, :null => false
      t.text :description
      t.string :homepage

      t.timestamps
    end
    add_index :projects, [:account_id, :shortname], :unique => true
  end
end
