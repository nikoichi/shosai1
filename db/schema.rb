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

ActiveRecord::Schema.define(version: 20160615041220) do

  create_table "books", force: :cascade do |t|
    t.string   "book_title",        limit: 255
    t.text     "book_img_url",      limit: 65535
    t.text     "amazon_detail_url", limit: 65535
    t.date     "publication_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_read_books", force: :cascade do |t|
    t.integer  "book_id",                          limit: 4
    t.integer  "user_id",                          limit: 4
    t.integer  "read_state",                       limit: 4
    t.date     "finish_reading_date"
    t.string   "review_title",                     limit: 255
    t.text     "review",                           limit: 65535
    t.text     "impressive_phrase",                limit: 65535
    t.text     "book_report",                      limit: 65535
    t.integer  "overall_rate",                     limit: 4
    t.integer  "change_life_rate",                 limit: 4
    t.integer  "learning_rate",                    limit: 4
    t.integer  "sympathy_rate",                    limit: 4
    t.integer  "interesting_rate",                 limit: 4
    t.integer  "impression_rate",                  limit: 4
    t.integer  "under_elementary_school_age_rate", limit: 4
    t.integer  "junior_high_school_student_rate",  limit: 4
    t.integer  "high_school_student_rate",         limit: 4
    t.integer  "university_student_rate",          limit: 4
    t.integer  "younger_20s_rate",                 limit: 4
    t.integer  "in_30s40s_rate",                   limit: 4
    t.integer  "in_50s60s_rate",                   limit: 4
    t.integer  "after_retirement_rate",            limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
