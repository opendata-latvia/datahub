class CreateForums < ActiveRecord::Migration
  def change
    create_table :forums do |t|
      t.string :title, :null => false
      t.string :slug, :null => false
      t.text :description, :null => false
      t.integer :position, :null => false
      t.timestamps
    end
    
    add_index :forums, :slug
  end
end
