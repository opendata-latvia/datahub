class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.integer :user_id
      t.string :login, :null => false, :limit => 40
      t.string :name, :default => ""

      t.timestamps
    end
    add_index :accounts, :user_id
    add_index :accounts, :login, :unique => true
  end
end
