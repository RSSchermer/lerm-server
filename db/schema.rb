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

ActiveRecord::Schema.define(version: 20160214102030) do

  create_table "data_elements", force: :cascade do |t|
    t.string   "label",       null: false
    t.text     "description"
    t.integer  "project_id",  null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "data_elements", ["label"], name: "index_data_elements_on_label"
  add_index "data_elements", ["project_id"], name: "index_data_elements_on_project_id"

  create_table "data_elements_phrases", id: false, force: :cascade do |t|
    t.integer "data_element_id"
    t.integer "phrase_id"
  end

  add_index "data_elements_phrases", ["data_element_id", "phrase_id"], name: "data_elements_phrases_index", unique: true

  create_table "memberships", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "memberships", ["project_id"], name: "index_memberships_on_project_id"
  add_index "memberships", ["user_id"], name: "index_memberships_on_user_id"

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id"
    t.string   "token",             null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        null: false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true

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
    t.string   "original_text",           null: false
    t.string   "cleaned_text"
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
    t.integer  "rule_one_id", null: false
    t.integer  "rule_two_id", null: false
    t.text     "description"
    t.integer  "project_id",  null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "rule_conflicts", ["project_id"], name: "index_rule_conflicts_on_project_id"
  add_index "rule_conflicts", ["rule_one_id"], name: "index_rule_conflicts_on_rule_one_id"
  add_index "rule_conflicts", ["rule_two_id"], name: "index_rule_conflicts_on_rule_two_id"

  create_table "rule_relationships", force: :cascade do |t|
    t.integer  "rule_one_id", null: false
    t.integer  "rule_two_id", null: false
    t.text     "description"
    t.integer  "project_id",  null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "rule_relationships", ["project_id"], name: "index_rule_relationships_on_project_id"
  add_index "rule_relationships", ["rule_one_id"], name: "index_rule_relationships_on_rule_one_id"
  add_index "rule_relationships", ["rule_two_id"], name: "index_rule_relationships_on_rule_two_id"

  create_table "rules", force: :cascade do |t|
    t.string   "label",                            null: false
    t.string   "source"
    t.text     "original_text"
    t.text     "proactive_form"
    t.integer  "formalization_status", default: 0
    t.integer  "project_id",                       null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "rules", ["label"], name: "index_rules_on_label"
  add_index "rules", ["project_id"], name: "index_rules_on_project_id"

  create_table "statements", force: :cascade do |t|
    t.text     "original_condition",                   null: false
    t.text     "original_consequence",                 null: false
    t.text     "cleaned_condition"
    t.text     "cleaned_consequence"
    t.boolean  "discarded",            default: false
    t.integer  "rule_id",                              null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
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
    t.string   "username",               default: "",    null: false
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "super_admin",            default: false, null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["username"], name: "index_users_on_username", unique: true

end
