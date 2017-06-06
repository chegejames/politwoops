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

ActiveRecord::Schema.define(version: 20160125211055) do

  create_table "account_links", force: :cascade do |t|
    t.integer  "politician_id", limit: 4
    t.integer  "link_id",       limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "account_types", force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "deleted_tweets", force: :cascade do |t|
    t.string   "user_name",           limit: 64
    t.string   "content",             limit: 255
    t.boolean  "deleted",                           default: false, null: false
    t.datetime "created",                                           null: false
    t.datetime "modified",                                          null: false
    t.text     "tweet",               limit: 65535
    t.integer  "politician_id",       limit: 4
    t.boolean  "approved",                          default: true
    t.boolean  "reviewed",                          default: true
    t.datetime "reviewed_at"
    t.text     "review_message",      limit: 65535
    t.integer  "retweeted_id",        limit: 8
    t.string   "retweeted_content",   limit: 255
    t.string   "retweeted_user_name", limit: 255
  end

  add_index "deleted_tweets", ["approved"], name: "index_deleted_tweets_on_approved", using: :btree
  add_index "deleted_tweets", ["content"], name: "index_tweets_on_content", using: :btree
  add_index "deleted_tweets", ["created"], name: "created", using: :btree
  add_index "deleted_tweets", ["deleted"], name: "deleted", using: :btree
  add_index "deleted_tweets", ["modified"], name: "index_deleted_tweets_on_modified", using: :btree
  add_index "deleted_tweets", ["modified"], name: "modified", using: :btree
  add_index "deleted_tweets", ["politician_id", "created"], name: "index_deleted_tweets_on_politician_id_and_created", using: :btree
  add_index "deleted_tweets", ["politician_id", "modified"], name: "index_deleted_tweets_on_politician_id_and_modified", using: :btree
  add_index "deleted_tweets", ["politician_id"], name: "index_tweets_on_politician_id", using: :btree
  add_index "deleted_tweets", ["reviewed"], name: "index_deleted_tweets_on_reviewed", using: :btree
  add_index "deleted_tweets", ["user_name"], name: "user_name", using: :btree

  create_table "offices", force: :cascade do |t|
    t.string "title",        limit: 255, null: false
    t.string "abbreviation", limit: 255, null: false
  end

  create_table "pages", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.string   "slug",       limit: 255
    t.text     "content",    limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "language",   limit: 255
  end

  add_index "pages", ["language"], name: "index_pages_on_language", using: :btree

  create_table "parties", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "display_name", limit: 255
  end

  add_index "parties", ["display_name"], name: "index_parties_on_display_name", unique: true, using: :btree
  add_index "parties", ["name"], name: "index_parties_on_name", unique: true, using: :btree

  create_table "politicians", force: :cascade do |t|
    t.string   "user_name",           limit: 64,                  null: false
    t.integer  "twitter_id",          limit: 8,                   null: false
    t.integer  "party_id",            limit: 4
    t.integer  "status",              limit: 4,     default: 1
    t.string   "profile_image_url",   limit: 255
    t.string   "state",               limit: 255
    t.integer  "account_type_id",     limit: 4
    t.integer  "office_id",           limit: 4
    t.string   "first_name",          limit: 255
    t.string   "middle_name",         limit: 255
    t.string   "last_name",           limit: 255
    t.string   "suffix",              limit: 255
    t.string   "avatar_file_name",    limit: 255
    t.string   "avatar_content_type", limit: 255
    t.integer  "avatar_file_size",    limit: 4
    t.datetime "avatar_updated_at"
    t.string   "gender",              limit: 255,   default: "U"
    t.string   "bioguide_id",         limit: 7
    t.text     "opencivicdata_id",    limit: 65535
  end

  add_index "politicians", ["status"], name: "index_politicians_on_status", using: :btree
  add_index "politicians", ["user_name", "first_name", "middle_name", "last_name"], name: "user_name_2", using: :btree
  add_index "politicians", ["user_name"], name: "user_name", using: :btree

  create_table "statistics", force: :cascade do |t|
    t.string   "what",       limit: 255
    t.date     "when"
    t.integer  "amount",     limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trends", force: :cascade do |t|
    t.integer  "year",       limit: 4
    t.integer  "month",      limit: 4
    t.string   "name",       limit: 255
    t.text     "value",      limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tweet_images", force: :cascade do |t|
    t.string   "url",        limit: 255
    t.integer  "tweet_id",   limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tweet_images", ["tweet_id"], name: "index_tweet_images_on_tweet_id", using: :btree
  add_index "tweet_images", ["tweet_id"], name: "tweet_id_tmpidx", using: :btree

  create_table "tweets", force: :cascade do |t|
    t.string   "user_name",           limit: 64
    t.string   "content",             limit: 255
    t.boolean  "deleted",                           default: false, null: false
    t.datetime "created",                                           null: false
    t.datetime "modified",                                          null: false
    t.text     "tweet",               limit: 65535
    t.integer  "politician_id",       limit: 4
    t.boolean  "approved",                          default: false
    t.boolean  "reviewed",                          default: false
    t.datetime "reviewed_at"
    t.text     "review_message",      limit: 65535
    t.integer  "retweeted_id",        limit: 8
    t.string   "retweeted_content",   limit: 255
    t.string   "retweeted_user_name", limit: 255
  end

  add_index "tweets", ["approved"], name: "index_tweets_on_approved", using: :btree
  add_index "tweets", ["content"], name: "index_tweets_on_content", using: :btree
  add_index "tweets", ["created"], name: "created", using: :btree
  add_index "tweets", ["deleted"], name: "deleted", using: :btree
  add_index "tweets", ["modified"], name: "index_tweets_on_modified", using: :btree
  add_index "tweets", ["modified"], name: "modified", using: :btree
  add_index "tweets", ["politician_id", "created"], name: "index_tweets_on_politician_id_and_created", using: :btree
  add_index "tweets", ["politician_id", "modified"], name: "index_tweets_on_politician_id_and_modified", using: :btree
  add_index "tweets", ["politician_id"], name: "index_tweets_on_politician_id", using: :btree
  add_index "tweets", ["reviewed"], name: "index_tweets_on_reviewed", using: :btree
  add_index "tweets", ["user_name"], name: "user_name", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "login",               limit: 255,             null: false
    t.string   "email",               limit: 255,             null: false
    t.string   "crypted_password",    limit: 255,             null: false
    t.string   "password_salt",       limit: 255,             null: false
    t.string   "persistence_token",   limit: 255,             null: false
    t.string   "single_access_token", limit: 255,             null: false
    t.string   "perishable_token",    limit: 255,             null: false
    t.integer  "login_count",         limit: 4,   default: 0, null: false
    t.integer  "failed_login_count",  limit: 4,   default: 0, null: false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip",    limit: 255
    t.string   "last_login_ip",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id",            limit: 4
    t.integer  "is_admin",            limit: 4
  end

end
