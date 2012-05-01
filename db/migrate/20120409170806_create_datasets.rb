class CreateDatasets < ActiveRecord::Migration
  def change
    create_table :datasets do |t|
      t.integer :project_id, :null => false
      t.string :shortname, :limit => 40, :null => false
      t.string :name, :null => false
      t.text :description
      t.string :source_url
      t.text :columns
      t.datetime :last_import_at

      t.timestamps
    end
    add_index :datasets, [:project_id, :shortname], :unique => true
  end
end
