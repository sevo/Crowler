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

ActiveRecord::Schema.define(:version => 20110905135229) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.text     "url"
    t.string   "ancestry"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["ancestry"], :name => "index_categories_on_ancestry"

  create_table "product_descriptions", :force => true do |t|
    t.text     "description"
    t.integer  "shop_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_images", :force => true do |t|
    t.integer  "product_id"
    t.text     "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", :force => true do |t|
    t.text     "name"
    t.text     "url"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "manufacturer"
    t.text     "short_description"
    t.text     "part_number"
    t.text     "ean"
  end

  create_table "shop_offers", :force => true do |t|
    t.integer  "shop_id"
    t.integer  "product_id"
    t.float    "cost"
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "url"
    t.string   "availability"
    t.float    "shipping"
  end

  create_table "shops", :force => true do |t|
    t.text     "name"
    t.text     "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
