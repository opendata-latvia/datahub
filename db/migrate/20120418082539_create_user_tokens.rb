class CreateUserTokens < ActiveRecord::Migration
  def change
    create_table :user_tokens do |t|
      t.integer :user_id
      t.string :provider
      t.string :uid

      t.timestamps
    end
  end
end
