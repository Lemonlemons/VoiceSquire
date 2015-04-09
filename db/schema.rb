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

ActiveRecord::Schema.define(version: 20150409054316) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "adminpack"

  create_table "countries", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dukes", force: :cascade do |t|
    t.string   "phonenumber"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "email"
    t.string   "mailingaddress"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "zipcode"
    t.integer  "preferredproposalmethod"
    t.datetime "birthday"
    t.boolean  "is_landline",                     default: false
    t.boolean  "is_mailingsameasphysicaladdress", default: true
    t.string   "physicaladdress"
    t.boolean  "is_female",                       default: false
    t.integer  "rating",                          default: 100
    t.integer  "numberofquests",                  default: 0
    t.integer  "numberofnotes",                   default: 0
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.integer  "squire_id"
    t.boolean  "registered",                      default: false
    t.integer  "activequest_id"
  end

  create_table "messages", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.boolean  "is_email",      default: false
    t.boolean  "is_text",       default: false
    t.integer  "squire_id"
    t.integer  "duke_id"
    t.integer  "quest_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "sentby_duke",   default: false
    t.boolean  "sentby_squire", default: false
  end

  create_table "notes", force: :cascade do |t|
    t.string   "title"
    t.text     "explanation"
    t.integer  "squire_id"
    t.integer  "duke_id"
    t.integer  "quest_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "quests", force: :cascade do |t|
    t.integer  "typeofquest"
    t.string   "audiolink"
    t.text     "textlink"
    t.integer  "squire_id"
    t.integer  "duke_id"
    t.boolean  "is_assigned",          default: false
    t.boolean  "is_proposalsent",      default: false
    t.boolean  "is_revisionrequested", default: false
    t.boolean  "is_proposalaccepted",  default: false
    t.boolean  "is_proofsubmitted",    default: false
    t.boolean  "is_completed",         default: false
    t.integer  "timesflagged",         default: 0
    t.string   "title"
    t.text     "description"
    t.integer  "pricetosquire",        default: 0
    t.integer  "totalprice",           default: 0
    t.integer  "squirescut",           default: 0
    t.string   "picture1"
    t.string   "picture2"
    t.string   "picture3"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "stripetoken"
    t.string   "proof1"
    t.string   "proof2"
    t.string   "proof3"
    t.text     "revision"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer  "rating"
    t.text     "explanation"
    t.integer  "squire_id"
    t.integer  "duke_id"
    t.integer  "quest_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "states", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                       default: "",    null: false
    t.string   "encrypted_password",          default: "",    null: false
    t.string   "firstname"
    t.string   "lastname"
    t.string   "phonenumber"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "zipcode"
    t.string   "publishable_key"
    t.string   "provider"
    t.string   "uid"
    t.string   "access_code"
    t.datetime "birthday"
    t.boolean  "is_female",                   default: false
    t.integer  "activequests",                default: 0
    t.integer  "completedquests",             default: 0
    t.integer  "totalcollected",              default: 0
    t.boolean  "completedbasictraining",      default: false
    t.boolean  "completedamazontraining",     default: false
    t.boolean  "completedtaskrabbittraining", default: false
    t.boolean  "completedinstacarttraining",  default: false
    t.text     "description"
    t.text     "question1"
    t.text     "question2"
    t.text     "question3"
    t.text     "question4"
    t.text     "question5"
    t.integer  "numberofquestsflagged",       default: 0
    t.integer  "numberofreviews",             default: 0
    t.integer  "reviewpercentage",            default: 100
    t.string   "businessname"
    t.integer  "numberofnotes",               default: 0
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",               default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "stripecomplete",              default: false
    t.boolean  "trainingcomplete",            default: false
    t.boolean  "interviewcomplete",           default: false
    t.boolean  "registrationcomplete",        default: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
