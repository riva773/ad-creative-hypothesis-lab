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

ActiveRecord::Schema[8.1].define(version: 2026_09_15_130000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "ad_tests", force: :cascade do |t|
    t.bigint "ad_id", null: false
    t.integer "amount_spent"
    t.integer "budget"
    t.integer "cpi"
    t.integer "cpm"
    t.datetime "created_at", null: false
    t.decimal "ctr"
    t.decimal "cvr"
    t.integer "impression"
    t.string "network"
    t.string "status", null: false
    t.date "test_end_date"
    t.date "test_start_date"
    t.datetime "updated_at", null: false
    t.index ["ad_id"], name: "index_ad_tests_on_ad_id"
    t.check_constraint "(cpi IS NULL OR cpi >= 0) AND (cpm IS NULL OR cpm >= 0) AND (impression IS NULL OR impression >= 0) AND (budget IS NULL OR budget >= 0) AND (amount_spent IS NULL OR amount_spent >= 0)", name: "ad_tests_non_negative_metrics"
    t.check_constraint "(ctr IS NULL OR ctr >= 0::numeric AND ctr <= 100::numeric) AND (cvr IS NULL OR cvr >= 0::numeric AND cvr <= 100::numeric)", name: "ad_tests_rate_range"
    t.check_constraint "amount_spent IS NULL OR budget IS NULL OR amount_spent <= budget", name: "ad_tests_amount_spent_lteq_budget"
    t.check_constraint "network IS NULL OR (network::text = ANY (ARRAY['Meta'::character varying::text, 'Google'::character varying::text, 'AppLovin'::character varying::text]))", name: "ad_tests_network_allowed"
    t.check_constraint "status::text = ANY (ARRAY['結果取り込み済み'::character varying, 'テスト結果待ち'::character varying, '振り返り済み'::character varying]::text[])", name: "ad_tests_status_allowed"
    t.check_constraint "test_start_date IS NULL OR test_end_date IS NULL OR test_end_date >= test_start_date", name: "ad_tests_test_end_date_gteq_start_date"
  end

  create_table "ads", force: :cascade do |t|
    t.bigint "app_id", null: false
    t.datetime "created_at", null: false
    t.string "file_name", null: false
    t.bigint "hypothesis_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["app_id", "file_name"], name: "index_ads_on_app_id_and_file_name", unique: true
    t.index ["app_id"], name: "index_ads_on_app_id"
    t.index ["hypothesis_id"], name: "index_ads_on_hypothesis_id", unique: true
    t.index ["user_id"], name: "index_ads_on_user_id"
  end

  create_table "apps", force: :cascade do |t|
    t.string "campaign_name", null: false
    t.datetime "created_at", null: false
    t.text "explanation"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["campaign_name"], name: "index_apps_on_campaign_name", unique: true
    t.index ["user_id"], name: "index_apps_on_user_id"
  end

  create_table "hypotheses", force: :cascade do |t|
    t.bigint "app_id", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["app_id"], name: "index_hypotheses_on_app_id"
    t.index ["user_id"], name: "index_hypotheses_on_user_id"
    t.check_constraint "char_length(content) <= 150", name: "hypotheses_content_length"
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "ad_test_id", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["ad_test_id"], name: "index_reviews_on_ad_test_id", unique: true
    t.index ["user_id"], name: "index_reviews_on_user_id"
    t.check_constraint "char_length(content) <= 1000", name: "reviews_content_length"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.check_constraint "char_length(name::text) <= 20", name: "users_name_length"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "ad_tests", "ads", on_delete: :cascade
  add_foreign_key "ads", "apps", on_delete: :cascade
  add_foreign_key "ads", "hypotheses", on_delete: :cascade
  add_foreign_key "ads", "users"
  add_foreign_key "apps", "users"
  add_foreign_key "hypotheses", "apps", on_delete: :cascade
  add_foreign_key "hypotheses", "users"
  add_foreign_key "reviews", "ad_tests", on_delete: :cascade
  add_foreign_key "reviews", "users"
end
