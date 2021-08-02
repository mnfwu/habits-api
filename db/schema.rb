# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_08_02_103217) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "goals", force: :cascade do |t|
    t.integer "percent_complete"
    t.date "end_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "group_id"
    t.index ["group_id"], name: "index_goals_on_group_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "habits", force: :cascade do |t|
    t.integer "steps_completed", default: 0
    t.bigint "master_habit_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "due_date"
    t.date "completed_date"
    t.boolean "completed_on_time"
    t.boolean "completed"
    t.string "name"
    t.text "frequency_options", default: [], array: true
    t.integer "total_steps", default: 0
    t.integer "week"
    t.boolean "missed"
    t.boolean "partially_completed"
    t.integer "weekly_percent_complete", default: 0
    t.index ["master_habit_id"], name: "index_habits_on_master_habit_id"
  end

  create_table "master_habits", force: :cascade do |t|
    t.string "name"
    t.text "frequency_options", default: [], array: true
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.integer "percent_complete", default: 0
    t.index ["user_id"], name: "index_master_habits_on_user_id"
  end

  create_table "steps", force: :cascade do |t|
    t.bigint "habit_id", null: false
    t.string "name"
    t.string "step_type"
    t.boolean "completed"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["habit_id"], name: "index_steps_on_habit_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "open_id"
    t.string "wechat_username"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "wechat_pic_url"
    t.integer "weekly_average", default: 0
  end

  create_table "users_groups", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "group_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["group_id"], name: "index_users_groups_on_group_id"
    t.index ["user_id"], name: "index_users_groups_on_user_id"
  end

  add_foreign_key "goals", "groups"
  add_foreign_key "habits", "master_habits"
  add_foreign_key "master_habits", "users"
  add_foreign_key "steps", "habits"
  add_foreign_key "users_groups", "groups"
  add_foreign_key "users_groups", "users"
end
