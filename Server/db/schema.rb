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

ActiveRecord::Schema.define(version: 20140423191248) do

  create_table "accounts", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.text     "encrypted_credit_card"
    t.string   "salt"
    t.integer  "user_id"
    t.string   "last_four"
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "division_price_points", force: true do |t|
    t.integer  "performance_id"
    t.integer  "division_id"
    t.decimal  "adult_price",    precision: 30, scale: 2
    t.decimal  "child_price",    precision: 30, scale: 2
    t.decimal  "military_price", precision: 30, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "divisions", force: true do |t|
    t.integer "theater_id"
    t.string  "name"
  end

  create_table "organizations", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "information"
    t.decimal  "default_adult",    precision: 30, scale: 2
    t.decimal  "default_child",    precision: 30, scale: 2
    t.decimal  "default_military", precision: 30, scale: 2
    t.decimal  "default_season",   precision: 30, scale: 2
  end

  create_table "performances", force: true do |t|
    t.string   "name"
    t.time     "performance_time"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "performance_start_date"
    t.date     "performance_end_date"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "production_id"
    t.integer  "transaction_id"
    t.decimal  "default_adult",          precision: 30, scale: 2
    t.decimal  "default_child",          precision: 30, scale: 2
    t.decimal  "default_military",       precision: 30, scale: 2
  end

  create_table "productions", force: true do |t|
    t.integer  "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.integer  "season_id"
    t.date     "start_date"
    t.text     "description"
    t.decimal  "default_adult",    precision: 30, scale: 2
    t.decimal  "default_child",    precision: 30, scale: 2
    t.decimal  "default_military", precision: 30, scale: 2
    t.integer  "theater_id"
  end

  create_table "season_tickets", force: true do |t|
    t.integer  "user_id"
    t.integer  "organization_id"
    t.integer  "seat_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "season_tickets_seats", id: false, force: true do |t|
    t.integer "season_ticket_id"
    t.integer "seat_id"
  end

  create_table "seasons", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organization_id"
    t.integer  "year"
    t.boolean  "current"
  end

  create_table "seats", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "row"
    t.integer  "seat_number"
    t.integer  "division_id"
    t.integer  "pixel_x"
    t.integer  "pixel_y"
  end

  create_table "supervisors", force: true do |t|
    t.string   "name"
    t.integer  "code"
    t.integer  "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "theaters", force: true do |t|
    t.string "name"
  end

  create_table "tickets", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "transaction_id"
    t.integer  "seat_id"
    t.integer  "performance_id"
    t.string   "seat_type"
    t.integer  "user_id"
  end

  add_index "tickets", ["transaction_id"], name: "index_tickets_on_transaction_id", using: :btree

  create_table "transactions", force: true do |t|
    t.integer  "ticket_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "performance_id"
    t.boolean  "pending"
    t.string   "customer_name"
    t.text     "encrypted_credit_card"
    t.boolean  "pay_at_door"
    t.boolean  "paid"
    t.decimal  "total",                 precision: 30, scale: 2
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "encrypted_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "account_level"
    t.integer  "organization_id"
    t.string   "name"
    t.string   "card_salt"
    t.string   "last_four"
    t.text     "encrypted_credit_card"
    t.string   "city"
    t.string   "street_address"
    t.string   "state"
  end

end
