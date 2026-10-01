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

ActiveRecord::Schema[8.1].define(version: 2026_10_01_062104) do
  create_table "admin_active_session_keys", primary_key: ["admin_id", "session_id"], force: :cascade do |t|
    t.integer "admin_id"
    t.string "session_id"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "last_use", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["admin_id"], name: "index_admin_active_session_keys_on_admin_id"
  end

  create_table "admin_authentication_audit_logs", force: :cascade do |t|
    t.integer "admin_id", null: false
    t.datetime "at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.text "message", null: false
    t.json "metadata"
    t.index ["admin_id", "at"], name: "audit_admin_admin_id_at_idx"
    t.index ["admin_id"], name: "index_admin_authentication_audit_logs_on_admin_id"
    t.index ["at"], name: "audit_admin_at_idx"
  end

  create_table "admin_lockouts", force: :cascade do |t|
    t.string "key", null: false
    t.datetime "deadline", null: false
    t.datetime "email_last_sent"
  end

  create_table "admin_login_failures", force: :cascade do |t|
    t.integer "number", default: 1, null: false
  end

  create_table "admin_otp_keys", force: :cascade do |t|
    t.string "key", null: false
    t.integer "num_failures", default: 0, null: false
    t.datetime "last_use", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "admin_password_reset_keys", force: :cascade do |t|
    t.string "key", null: false
    t.datetime "deadline", null: false
    t.datetime "email_last_sent", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "admin_recovery_codes", primary_key: ["id", "code"], force: :cascade do |t|
    t.bigint "id"
    t.string "code"
  end

  create_table "admin_remember_keys", force: :cascade do |t|
    t.string "key", null: false
    t.datetime "deadline", null: false
  end

  create_table "admin_verification_keys", force: :cascade do |t|
    t.string "key", null: false
    t.datetime "requested_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "email_last_sent", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "admins", force: :cascade do |t|
    t.integer "status", default: 1, null: false
    t.string "email", null: false
    t.string "password_hash"
    t.integer "role", default: 0, null: false
    t.index ["email"], name: "index_admins_on_email", unique: true, where: "status IN (1, 2)"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "website"
    t.text "description"
    t.string "city"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_companies_on_name", unique: true
    t.index ["slug"], name: "index_companies_on_slug", unique: true
  end

  create_table "company_user_invites", force: :cascade do |t|
    t.integer "company_id", null: false
    t.string "email", null: false
    t.text "token", null: false
    t.integer "role", default: 0, null: false
    t.integer "state", default: 0, null: false
    t.datetime "expires_at"
    t.datetime "accepted_at"
    t.string "invited_by_type", null: false
    t.integer "invited_by_id", null: false
    t.integer "user_id"
    t.string "invitable_type"
    t.integer "invitable_id"
    t.json "metadata", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id", "email"], name: "index_company_user_invites_on_entity_email_pending", unique: true, where: "state = 0"
    t.index ["company_id"], name: "index_company_user_invites_on_company_id"
    t.index ["invitable_type", "invitable_id"], name: "index_company_user_invites_on_invitable"
    t.index ["invitable_type", "invitable_id"], name: "index_company_user_invites_on_invitable_pending", unique: true, where: "state = 0 AND invitable_id IS NOT NULL"
    t.index ["invited_by_type", "invited_by_id"], name: "index_company_user_invites_on_invited_by"
    t.index ["token"], name: "index_company_user_invites_on_token", unique: true
    t.index ["user_id"], name: "index_company_user_invites_on_user_id"
  end

  create_table "company_users", force: :cascade do |t|
    t.integer "company_id", null: false
    t.integer "user_id", null: false
    t.integer "role", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id", "user_id"], name: "index_company_users_on_company_id_and_user_id", unique: true
    t.index ["company_id"], name: "index_company_users_on_company_id"
    t.index ["user_id"], name: "index_company_users_on_user_id"
  end

  create_table "developers_experiences", force: :cascade do |t|
    t.integer "profile_id", null: false
    t.integer "company_id"
    t.string "company_name", null: false
    t.string "title", null: false
    t.string "location"
    t.date "started_on", null: false
    t.date "ended_on"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_developers_experiences_on_company_id"
    t.index ["profile_id"], name: "index_developers_experiences_on_profile_id"
  end

  create_table "developers_profile_skills", force: :cascade do |t|
    t.integer "profile_id", null: false
    t.integer "skill_id", null: false
    t.integer "level"
    t.integer "years"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id", "skill_id"], name: "index_developers_profile_skills_on_profile_id_and_skill_id", unique: true
    t.index ["profile_id"], name: "index_developers_profile_skills_on_profile_id"
    t.index ["skill_id"], name: "index_developers_profile_skills_on_skill_id"
  end

  create_table "developers_profiles", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "handle", null: false
    t.string "name", null: false
    t.string "headline"
    t.text "bio"
    t.string "city"
    t.string "region"
    t.string "country"
    t.string "timezone"
    t.boolean "remote_ok", default: true, null: false
    t.boolean "open_to_relocation", default: false, null: false
    t.string "contact_email"
    t.string "phone"
    t.string "website_url"
    t.string "github_url"
    t.string "linkedin_url"
    t.string "x_url"
    t.integer "availability", default: 1, null: false
    t.integer "seniority"
    t.integer "years_experience"
    t.integer "contact_visibility", default: 1, null: false
    t.boolean "listed", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country"], name: "index_developers_profiles_on_country"
    t.index ["handle"], name: "index_developers_profiles_on_handle", unique: true
    t.index ["listed", "availability"], name: "index_developers_profiles_on_listed_and_availability"
    t.index ["user_id"], name: "index_developers_profiles_on_user_id", unique: true
  end

  create_table "hiring_job_applications", force: :cascade do |t|
    t.integer "job_post_id", null: false
    t.integer "profile_id", null: false
    t.text "cover_note"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_post_id", "profile_id"], name: "index_hiring_job_applications_on_job_post_id_and_profile_id", unique: true
    t.index ["job_post_id"], name: "index_hiring_job_applications_on_job_post_id"
    t.index ["profile_id"], name: "index_hiring_job_applications_on_profile_id"
  end

  create_table "hiring_job_posts", force: :cascade do |t|
    t.integer "company_id", null: false
    t.string "title", null: false
    t.text "description", null: false
    t.integer "employment_type", default: 0, null: false
    t.integer "seniority"
    t.integer "salary_min"
    t.integer "salary_max"
    t.string "salary_currency", default: "USD", null: false
    t.boolean "remote_ok", default: false, null: false
    t.string "city"
    t.string "country"
    t.string "apply_url"
    t.boolean "accepts_applications", default: true, null: false
    t.datetime "published_at"
    t.datetime "expires_at"
    t.datetime "filled_at"
    t.datetime "archived_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_hiring_job_posts_on_company_id"
    t.index ["published_at", "expires_at"], name: "index_hiring_job_posts_on_published_at_and_expires_at"
  end

  create_table "skills", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_skills_on_name", unique: true
    t.index ["slug"], name: "index_skills_on_slug", unique: true
  end

  create_table "user_login_change_keys", force: :cascade do |t|
    t.string "key", null: false
    t.string "login", null: false
    t.datetime "deadline", null: false
  end

  create_table "user_password_reset_keys", force: :cascade do |t|
    t.string "key", null: false
    t.datetime "deadline", null: false
    t.datetime "email_last_sent", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "user_remember_keys", force: :cascade do |t|
    t.string "key", null: false
    t.datetime "deadline", null: false
  end

  create_table "user_verification_keys", force: :cascade do |t|
    t.string "key", null: false
    t.datetime "requested_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "email_last_sent", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "users", force: :cascade do |t|
    t.integer "status", default: 1, null: false
    t.string "email", null: false
    t.string "password_hash"
    t.index ["email"], name: "index_users_on_email", unique: true, where: "status IN (1, 2)"
  end

  add_foreign_key "admin_active_session_keys", "admins"
  add_foreign_key "admin_authentication_audit_logs", "admins"
  add_foreign_key "admin_lockouts", "admins", column: "id"
  add_foreign_key "admin_login_failures", "admins", column: "id"
  add_foreign_key "admin_otp_keys", "admins", column: "id"
  add_foreign_key "admin_password_reset_keys", "admins", column: "id"
  add_foreign_key "admin_recovery_codes", "admins", column: "id"
  add_foreign_key "admin_remember_keys", "admins", column: "id"
  add_foreign_key "admin_verification_keys", "admins", column: "id"
  add_foreign_key "company_user_invites", "companies"
  add_foreign_key "company_user_invites", "users"
  add_foreign_key "company_users", "companies"
  add_foreign_key "company_users", "users"
  add_foreign_key "developers_experiences", "companies"
  add_foreign_key "developers_experiences", "developers_profiles", column: "profile_id"
  add_foreign_key "developers_profile_skills", "developers_profiles", column: "profile_id"
  add_foreign_key "developers_profile_skills", "skills"
  add_foreign_key "developers_profiles", "users"
  add_foreign_key "hiring_job_applications", "developers_profiles", column: "profile_id"
  add_foreign_key "hiring_job_applications", "hiring_job_posts", column: "job_post_id"
  add_foreign_key "hiring_job_posts", "companies"
  add_foreign_key "user_login_change_keys", "users", column: "id"
  add_foreign_key "user_password_reset_keys", "users", column: "id"
  add_foreign_key "user_remember_keys", "users", column: "id"
  add_foreign_key "user_verification_keys", "users", column: "id"
end
