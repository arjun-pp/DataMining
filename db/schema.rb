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

ActiveRecord::Schema.define(version: 20160826090400) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "areas", force: :cascade do |t|
    t.integer  "sectors_id"
    t.text     "name",       null: false
    t.text     "polygon"
    t.decimal  "lat"
    t.decimal  "long"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "areas", ["sectors_id"], name: "index_areas_on_sectors_id", using: :btree

  create_table "cities", force: :cascade do |t|
    t.text     "name",       null: false
    t.text     "polygon"
    t.decimal  "lat"
    t.decimal  "long"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "neighbourhood_data", force: :cascade do |t|
    t.text "name"
    t.text "source_url"
    t.text "html_data"
    t.text "data_css"
  end

  create_table "neighbourhoods", force: :cascade do |t|
    t.integer  "areas_id"
    t.text     "name",       null: false
    t.text     "polygon"
    t.decimal  "lat"
    t.decimal  "long"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "neighbourhoods", ["areas_id"], name: "index_neighbourhoods_on_areas_id", using: :btree

  create_table "sectors", force: :cascade do |t|
    t.integer  "cities_id"
    t.text     "name",             null: false
    t.text     "polygon"
    t.decimal  "lat"
    t.decimal  "long"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "real_estate_cost"
  end

  add_index "sectors", ["cities_id"], name: "index_sectors_on_cities_id", using: :btree

end
