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

ActiveRecord::Schema.define(:version => 20120129020603) do

  create_table "admins", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true
  add_index "admins", ["reset_password_token"], :name => "index_admins_on_reset_password_token", :unique => true

  create_table "attendants", :force => true do |t|
    t.integer  "user_id"
    t.integer  "invite_id"
    t.integer  "event_id"
    t.boolean  "is_co_organizer"
    t.string   "rsvp_status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attendants", ["event_id"], :name => "index_attendants_on_event_id"
  add_index "attendants", ["invite_id"], :name => "index_attendants_on_invite_id"
  add_index "attendants", ["user_id"], :name => "index_attendants_on_user_id"

  create_table "audios", :force => true do |t|
    t.integer  "user_id"
    t.string   "url"
    t.text     "description"
    t.integer  "duration",    :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.string   "secret"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authentications", ["provider", "uid"], :name => "index_authentications_on_provider_and_uid", :unique => true
  add_index "authentications", ["user_id"], :name => "index_authentications_on_user_id"

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["event_id"], :name => "index_comments_on_event_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "event_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.integer  "user_id",       :null => false
    t.integer  "event_type_id"
    t.string   "name"
    t.text     "description"
    t.datetime "when"
    t.datetime "start_time"
    t.datetime "end_time"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "venue"
  end

  add_index "events", ["user_id"], :name => "index_events_on_user_id"

  create_table "friendships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invites", :force => true do |t|
    t.integer  "user_id"
    t.string   "email"
    t.string   "name"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invites", ["email", "token"], :name => "index_invites_on_email_and_token"
  add_index "invites", ["user_id"], :name => "index_invites_on_user_id"

  create_table "model_metas", :force => true do |t|
    t.string  "key",      :null => false
    t.string  "model",    :null => false
    t.integer "model_id", :null => false
    t.string  "value",    :null => false
  end

  add_index "model_metas", ["model", "key", "model_id"], :name => "index_model_metas_on_model_and_key_and_model_id"

  create_table "rails_admin_histories", :force => true do |t|
    t.string   "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_histories_on_item_and_table_and_month_and_year"

  create_table "social_times", :force => true do |t|
    t.integer  "user_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_secondary_emails", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.string   "email",      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_secondary_emails", ["email"], :name => "index_user_secondary_emails_on_email"
  add_index "user_secondary_emails", ["user_id"], :name => "index_user_secondary_emails_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "first_name",             :limit => 45
    t.string   "last_name",              :limit => 45
    t.string   "gender",                 :limit => 10
    t.string   "email",                                 :default => "", :null => false
    t.string   "phone"
    t.string   "api_token"
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
