# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120516105732) do

  create_table "accounts", :force => true do |t|
    t.integer  "user_id"
    t.string   "login",      :limit => 40,                 :null => false
    t.string   "name",                     :default => ""
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  add_index "accounts", ["login"], :name => "index_accounts_on_login", :unique => true
  add_index "accounts", ["user_id"], :name => "index_accounts_on_user_id"

  create_table "comments", :force => true do |t|
    t.string   "commentable_type", :null => false
    t.integer  "commentable_id",   :null => false
    t.integer  "user_id",          :null => false
    t.text     "content",          :null => false
    t.string   "ancestry"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "comments", ["commentable_type", "commentable_id"], :name => "index_comments_on_commentable_type_and_commentable_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "datasets", :force => true do |t|
    t.integer  "project_id",                   :null => false
    t.string   "shortname",      :limit => 40, :null => false
    t.string   "name",                         :null => false
    t.text     "description"
    t.string   "source_url"
    t.text     "columns"
    t.datetime "last_import_at"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "datasets", ["project_id", "shortname"], :name => "index_datasets_on_project_id_and_shortname", :unique => true

  create_table "forums", :force => true do |t|
    t.string   "title",       :null => false
    t.string   "slug",        :null => false
    t.text     "description", :null => false
    t.integer  "position",    :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "forums", ["slug"], :name => "index_forums_on_slug"

  create_table "projects", :force => true do |t|
    t.integer  "account_id",                :null => false
    t.string   "shortname",   :limit => 40, :null => false
    t.string   "name",                      :null => false
    t.text     "description"
    t.string   "homepage"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "projects", ["account_id", "shortname"], :name => "index_projects_on_account_id_and_shortname", :unique => true

  create_table "source_files", :force => true do |t|
    t.integer  "dataset_id"
    t.string   "source_file_name"
    t.string   "source_content_type", :limit => 50
    t.integer  "source_file_size"
    t.datetime "source_updated_at"
    t.string   "status",              :limit => 20
    t.integer  "header_rows_count"
    t.integer  "data_rows_count"
    t.datetime "imported_at"
    t.string   "error_message"
    t.datetime "error_at"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "source_files", ["dataset_id"], :name => "index_source_files_on_dataset_id"

  create_table "topics", :force => true do |t|
    t.integer  "forum_id",                       :null => false
    t.integer  "user_id",                        :null => false
    t.string   "title",                          :null => false
    t.string   "slug",                           :null => false
    t.text     "description",                    :null => false
    t.boolean  "commentable", :default => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "topics", ["forum_id", "slug"], :name => "index_topics_on_forum_id_and_slug"
  add_index "topics", ["forum_id", "updated_at"], :name => "index_topics_on_forum_id_and_updated_at"
  add_index "topics", ["forum_id"], :name => "index_topics_on_forum_id"

  create_table "user_tokens", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_tokens", ["provider", "uid"], :name => "index_user_tokens_on_provider_and_uid"
  add_index "user_tokens", ["user_id"], :name => "index_user_tokens_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "login",                  :limit => 40,                 :null => false
    t.string   "name",                                 :default => ""
    t.boolean  "super_admin"
    t.string   "email",                                :default => "", :null => false
    t.string   "encrypted_password",                   :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",                      :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["login"], :name => "index_users_on_login", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

end
