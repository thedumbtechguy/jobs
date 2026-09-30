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

ActiveRecord::Schema[8.1].define(version: 0) do
  create_table "rails_pulse_deployments", force: :cascade do |t|
    t.string "revision", null: false
    t.datetime "started_at", null: false
    t.datetime "finished_at"
    t.text "metadata"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["revision"], name: "index_rails_pulse_deployments_on_revision"
    t.index ["started_at"], name: "index_rails_pulse_deployments_on_started_at"
  end

  create_table "rails_pulse_exception_groups", force: :cascade do |t|
    t.string "fingerprint", null: false
    t.string "exception_class", null: false
    t.string "location"
    t.text "message"
    t.datetime "first_seen_at", null: false
    t.datetime "last_seen_at", null: false
    t.integer "occurrence_count", default: 0, null: false
    t.string "status", default: "open", null: false
    t.datetime "resolved_at"
    t.boolean "preserve", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exception_class"], name: "index_rp_exception_groups_on_class"
    t.index ["fingerprint"], name: "index_rp_exception_groups_on_fingerprint", unique: true
    t.index ["last_seen_at"], name: "index_rp_exception_groups_on_last_seen_at"
    t.index ["status"], name: "index_rp_exception_groups_on_status"
  end

  create_table "rails_pulse_exception_occurrences", force: :cascade do |t|
    t.integer "exception_group_id", null: false
    t.string "exception_class", null: false
    t.text "message"
    t.text "backtrace"
    t.string "request_url"
    t.string "request_method"
    t.string "environment"
    t.string "deploy_sha"
    t.text "request_params"
    t.datetime "occurred_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exception_group_id"], name: "index_rp_exception_occurrences_on_group_id"
    t.index ["occurred_at"], name: "index_rp_exception_occurrences_on_occurred_at"
  end

  create_table "rails_pulse_job_runs", force: :cascade do |t|
    t.integer "job_id", null: false
    t.string "run_id", null: false
    t.decimal "duration", precision: 15, scale: 6
    t.string "status", null: false
    t.string "error_class"
    t.text "error_message"
    t.integer "attempts", default: 0, null: false
    t.datetime "occurred_at", null: false
    t.datetime "enqueued_at"
    t.text "arguments"
    t.string "adapter"
    t.text "tags"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id", "occurred_at"], name: "index_rails_pulse_job_runs_on_job_and_occurred"
    t.index ["job_id", "status"], name: "index_rails_pulse_job_runs_on_job_and_status"
    t.index ["job_id"], name: "index_rails_pulse_job_runs_on_job_id"
    t.index ["occurred_at"], name: "index_rails_pulse_job_runs_on_occurred_at"
    t.index ["run_id"], name: "index_rails_pulse_job_runs_on_run_id", unique: true
    t.index ["status"], name: "index_rails_pulse_job_runs_on_status"
  end

  create_table "rails_pulse_jobs", force: :cascade do |t|
    t.string "name", null: false
    t.string "queue_name"
    t.text "description"
    t.integer "runs_count", default: 0, null: false
    t.integer "failures_count", default: 0, null: false
    t.integer "retries_count", default: 0, null: false
    t.decimal "avg_duration", precision: 15, scale: 6
    t.decimal "p95_duration", precision: 15, scale: 6
    t.decimal "p99_duration", precision: 15, scale: 6
    t.text "tags"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_rails_pulse_jobs_on_name", unique: true
    t.index ["queue_name"], name: "index_rails_pulse_jobs_on_queue"
    t.index ["runs_count"], name: "index_rails_pulse_jobs_on_runs_count"
  end

  create_table "rails_pulse_operations", force: :cascade do |t|
    t.integer "request_id"
    t.integer "job_run_id"
    t.integer "query_id"
    t.string "operation_type", null: false
    t.string "label", null: false
    t.decimal "duration", precision: 15, scale: 6, null: false
    t.string "codebase_location"
    t.float "start_time", default: 0.0, null: false
    t.datetime "occurred_at", null: false
    t.integer "row_count"
    t.boolean "cache_hit"
    t.text "actual_sql"
    t.text "repeated_query_group"
    t.integer "repetition_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at", "query_id"], name: "idx_operations_for_aggregation"
    t.index ["job_run_id"], name: "index_rails_pulse_operations_on_job_run_id"
    t.index ["occurred_at", "duration", "operation_type"], name: "index_rails_pulse_operations_on_time_duration_type"
    t.index ["operation_type"], name: "index_rails_pulse_operations_on_operation_type"
    t.index ["query_id", "duration", "occurred_at"], name: "index_rails_pulse_operations_query_performance"
    t.index ["query_id", "occurred_at"], name: "index_rails_pulse_operations_on_query_and_time"
    t.index ["request_id"], name: "index_rails_pulse_operations_on_request_id"
  end

  create_table "rails_pulse_queries", force: :cascade do |t|
    t.string "hashed_sql", limit: 32, null: false
    t.text "normalized_sql", null: false
    t.datetime "analyzed_at"
    t.text "explain_plan"
    t.text "issues"
    t.text "metadata"
    t.text "query_stats"
    t.text "backtrace_analysis"
    t.text "index_recommendations"
    t.text "n_plus_one_analysis"
    t.text "suggestions"
    t.text "tags"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hashed_sql"], name: "index_rails_pulse_queries_on_hashed_sql", unique: true
  end

  create_table "rails_pulse_requests", force: :cascade do |t|
    t.integer "route_id", null: false
    t.string "method"
    t.decimal "duration", precision: 15, scale: 6, null: false
    t.integer "status", null: false
    t.boolean "is_error", default: false, null: false
    t.string "request_uuid", null: false
    t.string "controller_action"
    t.datetime "occurred_at", null: false
    t.text "tags"
    t.integer "response_size_bytes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at", "route_id"], name: "idx_requests_for_aggregation"
    t.index ["occurred_at"], name: "index_rails_pulse_requests_on_occurred_at"
    t.index ["request_uuid"], name: "index_rails_pulse_requests_on_request_uuid", unique: true
    t.index ["route_id", "occurred_at"], name: "index_rails_pulse_requests_on_route_id_and_occurred_at"
    t.index ["route_id"], name: "index_rails_pulse_requests_on_route_id"
  end

  create_table "rails_pulse_routes", force: :cascade do |t|
    t.text "http_methods", null: false
    t.string "path", null: false
    t.text "tags"
    t.string "controller_action"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["controller_action", "path"], name: "index_rails_pulse_routes_on_controller_action_and_path", unique: true
    t.index ["path"], name: "index_rails_pulse_routes_on_path"
    t.index ["path"], name: "index_rails_pulse_routes_on_path_without_action", unique: true, where: "controller_action IS NULL"
  end

  create_table "rails_pulse_summaries", force: :cascade do |t|
    t.datetime "period_start", null: false
    t.datetime "period_end", null: false
    t.string "period_type", null: false
    t.string "summarizable_type", null: false
    t.integer "summarizable_id", null: false
    t.integer "count", default: 0, null: false
    t.float "avg_duration"
    t.float "min_duration"
    t.float "max_duration"
    t.float "p50_duration"
    t.float "p95_duration"
    t.float "p99_duration"
    t.float "total_duration"
    t.float "stddev_duration"
    t.integer "error_count", default: 0
    t.integer "success_count", default: 0
    t.integer "status_2xx", default: 0
    t.integer "status_3xx", default: 0
    t.integer "status_4xx", default: 0
    t.integer "status_5xx", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_rails_pulse_summaries_on_created_at"
    t.index ["period_start"], name: "index_rails_pulse_summaries_on_period_start"
    t.index ["period_type", "period_start"], name: "index_rails_pulse_summaries_on_period"
    t.index ["summarizable_id"], name: "index_rails_pulse_summaries_on_summarizable_id"
    t.index ["summarizable_type", "summarizable_id", "period_type", "period_start"], name: "idx_pulse_summaries_unique", unique: true
    t.index ["summarizable_type", "summarizable_id"], name: "index_rails_pulse_summaries_on_summarizable"
  end

  add_foreign_key "rails_pulse_exception_occurrences", "rails_pulse_exception_groups", column: "exception_group_id"
  add_foreign_key "rails_pulse_job_runs", "rails_pulse_jobs", column: "job_id"
  add_foreign_key "rails_pulse_operations", "rails_pulse_job_runs", column: "job_run_id"
  add_foreign_key "rails_pulse_operations", "rails_pulse_queries", column: "query_id"
  add_foreign_key "rails_pulse_operations", "rails_pulse_requests", column: "request_id"
  add_foreign_key "rails_pulse_requests", "rails_pulse_routes", column: "route_id"
end
