class CreateUserTokens < ActiveRecord::Migration
  def change
    create_table :user_tokens do |t|
      t.integer :user_id, :null => false
      t.string :provider, :null => false
      t.string :uid, :null => false

      t.timestamps
    end
    add_index :user_tokens, :user_id
    add_index :user_tokens, [:provider, :uid]
  end
end
