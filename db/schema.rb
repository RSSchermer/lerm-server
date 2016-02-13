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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160213204311) do

  create_table "memberships", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "memberships", ["project_id"], name: "index_memberships_on_project_id"
  add_index "memberships", ["user_id"], name: "index_memberships_on_user_id"

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "user_id",        null: false
    t.integer  "application_id", null: false
    t.string   "token",          null: false
    t.integer  "expires_in",     null: false
    t.text     "redirect_uri",   null: false
    t.datetime "created_at",     null: false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "user_id",        null: false
    t.integer  "application_id"
    t.string   "token",          null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",     null: false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  add_index "oauth_access_tokens", ["user_id"], name: "index_oauth_access_tokens_on_user_id"

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",                      null: false
    t.string   "uid",                       null: false
    t.string   "secret",                    null: false
    t.text     "redirect_uri",              null: false
    t.string   "scopes",       default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true

  create_table "phrases", force: :cascade do |t|
    t.string   "text"
    t.string   "clean_text"
    t.boolean  "discarded"
    t.boolean  "crisp"
    t.text     "data_element_expression"
    t.integer  "rule_id",                 null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "phrases", ["rule_id"], name: "index_phrases_on_rule_id"

  create_table "projects", force: :cascade do |t|
    t.string   "name",        null: false
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "projects", ["name"], name: "index_projects_on_name", unique: true

  create_table "rule_conflicts", force: :cascade do |t|
    t.integer  "rule_1_id"
    t.integer  "rule_2_id"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "rule_conflicts", ["rule_1_id"], name: "index_rule_conflicts_on_rule_1_id"
  add_index "rule_conflicts", ["rule_2_id"], name: "index_rule_conflicts_on_rule_2_id"

  create_table "rules", force: :cascade do |t|
    t.string   "label",          null: false
    t.string   "source"
    t.text     "original_text"
    t.text     "proactive_form"
    t.integer  "project_id",     null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "rules", ["label"], name: "index_rules_on_label"
  add_index "rules", ["project_id"], name: "index_rules_on_project_id"

  create_table "statements", force: :cascade do |t|
    t.text     "condition"
    t.text     "consequence"
    t.text     "cleaned_condition"
    t.text     "cleaned_consequence"
    t.boolean  "discarded",           default: false
    t.integer  "rule_id",                             null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "statements", ["rule_id"], name: "index_statements_on_rule_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "super_admin",            default: false, null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
