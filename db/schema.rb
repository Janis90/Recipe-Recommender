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

ActiveRecord::Schema.define(version: 20161215214606) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "allergies", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.date     "date"
    t.time     "start_time"
    t.time     "end_time"
    t.integer  "creator_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "events", ["creator_id"], name: "index_events_on_creator_id", using: :btree

  create_table "friendships", force: :cascade do |t|
    t.integer  "friendable_id"
    t.string   "friendable_type"
    t.integer  "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "blocker_id"
    t.integer  "status"
  end

  create_table "ingredients", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "is_foodcategory", default: false
  end

  add_index "ingredients", ["name"], name: "index_ingredients_on_name", unique: true, using: :btree

  create_table "recipe_allergies", force: :cascade do |t|
    t.integer  "recipe_id"
    t.integer  "allergy_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "recipe_allergies", ["allergy_id"], name: "index_recipe_allergies_on_allergy_id", using: :btree
  add_index "recipe_allergies", ["recipe_id", "allergy_id"], name: "index_recipe_allergies_on_recipe_id_and_allergy_id", unique: true, using: :btree
  add_index "recipe_allergies", ["recipe_id"], name: "index_recipe_allergies_on_recipe_id", using: :btree

  create_table "recipe_ingredients", force: :cascade do |t|
    t.integer  "recipe_id"
    t.integer  "ingredient_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "recipe_ingredients", ["ingredient_id"], name: "index_recipe_ingredients_on_ingredient_id", using: :btree
  add_index "recipe_ingredients", ["recipe_id", "ingredient_id"], name: "index_recipe_ingredients_on_recipe_id_and_ingredient_id", unique: true, using: :btree
  add_index "recipe_ingredients", ["recipe_id"], name: "index_recipe_ingredients_on_recipe_id", using: :btree

  create_table "recipes", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.text     "instructions"
    t.string   "picture_url"
    t.string   "menu_type"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "recipe_creator_id"
  end

  add_index "recipes", ["recipe_creator_id"], name: "index_recipes_on_recipe_creator_id", using: :btree

  create_table "user_allergies", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "allergy_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_allergies", ["allergy_id"], name: "index_user_allergies_on_allergy_id", using: :btree
  add_index "user_allergies", ["user_id"], name: "index_user_allergies_on_user_id", using: :btree

  create_table "user_events", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_events", ["event_id"], name: "index_user_events_on_event_id", using: :btree
  add_index "user_events", ["user_id"], name: "index_user_events_on_user_id", using: :btree

  create_table "user_ingredients", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "ingredient_id"
    t.integer  "rating",        default: 3
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "user_ingredients", ["ingredient_id"], name: "index_user_ingredients_on_ingredient_id", using: :btree
  add_index "user_ingredients", ["user_id"], name: "index_user_ingredients_on_user_id", using: :btree

  create_table "user_recipes", force: :cascade do |t|
    t.integer  "recipe_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_recipes", ["recipe_id"], name: "index_user_recipes_on_recipe_id", using: :btree
  add_index "user_recipes", ["user_id"], name: "index_user_recipes_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "admin",                  default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  add_foreign_key "recipe_allergies", "allergies"
  add_foreign_key "recipe_allergies", "recipes"
  add_foreign_key "recipe_ingredients", "ingredients"
  add_foreign_key "recipe_ingredients", "recipes"
  add_foreign_key "user_allergies", "allergies"
  add_foreign_key "user_allergies", "users"
  add_foreign_key "user_events", "events"
  add_foreign_key "user_events", "users"
  add_foreign_key "user_ingredients", "ingredients"
  add_foreign_key "user_ingredients", "users"
  add_foreign_key "user_recipes", "recipes"
  add_foreign_key "user_recipes", "users"
end
