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

ActiveRecord::Schema.define(:version => 20110906103017) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.text     "url"
    t.string   "ancestry"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["ancestry"], :name => "index_categories_on_ancestry"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "product_descriptions", :force => true do |t|
    t.text     "description"
    t.integer  "shop_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_descriptions", ["product_id"], :name => "index_product_descriptions_on_product_id"
  add_index "product_descriptions", ["shop_id"], :name => "index_product_descriptions_on_shop_id"

  create_table "product_images", :force => true do |t|
    t.integer  "product_id"
    t.text     "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_images", ["product_id"], :name => "index_product_images_on_product_id"
  add_index "product_images", ["url"], :name => "index_product_images_on_url", :length => {"url"=>255}

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

  add_index "products", ["name"], :name => "index_products_on_name", :length => {"name"=>255}
  add_index "products", ["url"], :name => "index_products_on_url", :length => {"url"=>255}

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

  add_index "shop_offers", ["product_id"], :name => "index_shop_offers_on_product_id"
  add_index "shop_offers", ["shop_id"], :name => "index_shop_offers_on_shop_id"

  create_table "shops", :force => true do |t|
    t.text     "name"
    t.text     "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shops", ["name"], :name => "index_shops_on_name", :length => {"name"=>255}
  add_index "shops", ["url"], :name => "index_shops_on_url", :length => {"url"=>255}

  create_table "xml_feed_handlers", :force => true do |t|
    t.text     "feed_url"
    t.string   "status"
    t.text     "result"
    t.integer  "shop_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
