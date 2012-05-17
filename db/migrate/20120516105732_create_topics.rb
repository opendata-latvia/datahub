class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.references :forum, :null => false
      t.references :user, :null => false
      t.string :title, :null => false
      t.string :slug, :null => false
      t.text :description, :null => false
      t.boolean :commentable, :default => false

      t.timestamps
    end
    
    add_index :topics, :forum_id
    add_index :topics, [:forum_id, :slug]
    add_index :topics, [:forum_id, :updated_at]
  end
end
