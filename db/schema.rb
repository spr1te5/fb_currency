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

ActiveRecord::Schema.define(version: 2020_11_23_063152) do

  create_table "currency_exchange_rates", force: :cascade do |t|
    t.integer "from_code"
    t.integer "to_code"
    t.integer "forced_rate", limit: 8
    t.date "valid_until"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "source_rate", limit: 8
    t.integer "forced_rate_degree", limit: 1
    t.integer "source_rate_degree", limit: 1
    t.boolean "updated"
  end

end
