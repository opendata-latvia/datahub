class CreateSourceFiles < ActiveRecord::Migration
  def change
    create_table :source_files do |t|
      t.integer :dataset_id
      # paperclip fields
      t.string    :source_file_name
      t.string    :source_content_type, :limit => 50
      t.integer   :source_file_size
      t.datetime  :source_updated_at
      # other fields
      t.string    :status, :limit => 20
      t.integer   :header_rows_count
      t.integer   :data_rows_count
      t.datetime  :imported_at
      t.string    :error_message
      t.datetime  :error_at
      t.timestamps
    end
    add_index :source_files, :dataset_id
  end
end
