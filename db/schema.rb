# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_09_20_153243) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "businesses", force: :cascade do |t|
    t.bigint "organization_id"
    t.bigint "business_category_id"
    t.string "name"
    t.string "address"
    t.string "phone_no"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["business_category_id"], name: "index_businesses_on_business_category_id"
    t.index ["organization_id"], name: "index_businesses_on_organization_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "owned_by"
    t.string "name"
    t.string "address"
    t.string "phone_no"
    t.string "email"
    t.float "package_price"
    t.bigint "package_id"
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "business_limit"
    t.index ["package_id"], name: "index_organizations_on_package_id"
  end

  create_table "packages", force: :cascade do |t|
    t.string "name"
    t.float "price"
    t.string "price_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "business_limit"
  end

  create_table "products", force: :cascade do |t|
    t.bigint "business_id"
    t.string "name"
    t.integer "stock_available"
    t.integer "out_of_stock_limit"
    t.float "cost_price"
    t.float "sell_price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["business_id"], name: "index_products_on_business_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "staffs", force: :cascade do |t|
    t.bigint "organization_id"
    t.bigint "business_id"
    t.bigint "role_id"
    t.string "name"
    t.string "phone_no"
    t.string "address"
    t.float "salary"
    t.boolean "salary_paid"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["business_id"], name: "index_staffs_on_business_id"
    t.index ["organization_id"], name: "index_staffs_on_organization_id"
    t.index ["role_id"], name: "index_staffs_on_role_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.bigint "organization_id"
    t.bigint "role_id"
    t.bigint "staff_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["organization_id"], name: "index_users_on_organization_id"
    t.index ["role_id"], name: "index_users_on_role_id"
    t.index ["staff_id"], name: "index_users_on_staff_id"
  end

end
