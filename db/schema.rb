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

ActiveRecord::Schema[8.0].define(version: 2025_03_11_113429) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "appointments", force: :cascade do |t|
    t.bigint "slot_id", null: false
    t.bigint "patient_profile_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_profile_id"], name: "index_appointments_on_patient_profile_id"
    t.index ["slot_id"], name: "index_appointments_on_slot_id"
  end

  create_table "beds", force: :cascade do |t|
    t.bigint "room_id", null: false
    t.string "bed_number"
    t.integer "status", default: 0
    t.bigint "patient_profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_profile_id"], name: "index_beds_on_patient_profile_id"
    t.index ["room_id"], name: "index_beds_on_room_id"
  end

  create_table "consultations", force: :cascade do |t|
    t.bigint "doctor_profile_id", null: false
    t.bigint "patient_profile_id", null: false
    t.text "comments"
    t.text "condition"
    t.text "medication"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["doctor_profile_id"], name: "index_consultations_on_doctor_profile_id"
    t.index ["patient_profile_id"], name: "index_consultations_on_patient_profile_id"
  end

  create_table "departments", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_departments_on_user_id"
  end

  create_table "doctor_profiles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.date "date_of_birth"
    t.string "contact_number"
    t.string "nationality"
    t.string "gender"
    t.text "qualifications"
    t.text "experience"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "creator_id"
    t.integer "updator_id"
    t.bigint "department_id"
    t.string "email"
    t.index ["department_id"], name: "index_doctor_profiles_on_department_id"
    t.index ["user_id"], name: "index_doctor_profiles_on_user_id"
  end

  create_table "patient_profiles", force: :cascade do |t|
    t.bigint "user_id"
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.date "date_of_birth"
    t.text "address"
    t.string "contact_number"
    t.string "gender"
    t.string "blood_group"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.index ["user_id"], name: "index_patient_profiles_on_user_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.bigint "department_id", null: false
    t.string "room_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["department_id"], name: "index_rooms_on_department_id"
    t.index ["user_id"], name: "index_rooms_on_user_id"
  end

  create_table "slots", force: :cascade do |t|
    t.bigint "doctor_profile_id", null: false
    t.datetime "start_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "patient_profiles_id"
    t.datetime "end_time"
    t.index ["doctor_profile_id"], name: "index_slots_on_doctor_profile_id"
    t.index ["patient_profiles_id"], name: "index_slots_on_patient_profiles_id"
    t.index ["user_id"], name: "index_slots_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role"
    t.string "name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "appointments", "patient_profiles"
  add_foreign_key "appointments", "slots"
  add_foreign_key "beds", "patient_profiles"
  add_foreign_key "beds", "rooms"
  add_foreign_key "consultations", "doctor_profiles"
  add_foreign_key "consultations", "patient_profiles"
  add_foreign_key "departments", "users"
  add_foreign_key "doctor_profiles", "departments"
  add_foreign_key "doctor_profiles", "users"
  add_foreign_key "patient_profiles", "users"
  add_foreign_key "rooms", "departments"
  add_foreign_key "rooms", "users"
  add_foreign_key "slots", "doctor_profiles"
  add_foreign_key "slots", "patient_profiles", column: "patient_profiles_id"
  add_foreign_key "slots", "users"
end
