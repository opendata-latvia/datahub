class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :commentable_type, :null => false
      t.integer :commentable_id, :null => false
      t.references :user, :null => false
      t.text :content, :null => false
      t.string :ancestry

      t.timestamps
    end
    add_index :comments, :user_id
    add_index :comments, [:commentable_type, :commentable_id]
  end
end
