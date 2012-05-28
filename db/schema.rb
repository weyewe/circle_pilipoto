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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120528083707) do

  create_table "article_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "article_pictures", :force => true do |t|
    t.string   "name"
    t.integer  "article_id"
    t.string   "original_image_url"
    t.string   "article_image_url"
    t.string   "front_page_image_url"
    t.string   "index_image_url"
    t.integer  "original_image_size"
    t.integer  "article_image_size"
    t.integer  "front_page_image_size"
    t.integer  "index_image_size"
    t.integer  "article_display_order",      :default => 0
    t.boolean  "is_displayed",               :default => false
    t.boolean  "is_displayed_at_front_page", :default => false
    t.boolean  "is_displayed_as_teaser",     :default => false
    t.boolean  "is_deleted",                 :default => false
    t.integer  "article_picture_type",       :default => 1
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.integer  "front_page_width"
    t.integer  "front_page_height"
    t.boolean  "is_selected_front_page",     :default => false
  end

  create_table "articles", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.text     "teaser"
    t.integer  "project_id"
    t.integer  "company_id"
    t.integer  "user_id"
    t.integer  "article_type",         :default => 1
    t.boolean  "has_front_page_image", :default => false
    t.integer  "article_category_id"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.boolean  "is_displayed",         :default => false
    t.datetime "publication_datetime"
  end

  create_table "assignments", :force => true do |t|
    t.integer  "role_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "comments", :force => true do |t|
    t.integer  "commentable_id",   :default => 0
    t.string   "commentable_type", :default => ""
    t.string   "title",            :default => ""
    t.text     "body",             :default => ""
    t.string   "subject",          :default => ""
    t.integer  "user_id",          :default => 0,  :null => false
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "companies", :force => true do |t|
    t.string   "facebook_link"
    t.string   "twitter_link"
    t.string   "linkedin_link"
    t.string   "name"
    t.string   "phone_number"
    t.string   "contact_email"
    t.string   "website_address"
    t.text     "office_address"
    t.integer  "delivery_method",          :default => 1
    t.integer  "integer",                  :default => 1
    t.string   "scheduled_delivery_hours", :default => ""
    t.string   "string",                   :default => ""
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "enrollments", :force => true do |t|
    t.integer  "company_id"
    t.integer  "user_id"
    t.string   "enrollment_code"
    t.boolean  "is_current_perspective", :default => true
    t.boolean  "is_active",              :default => true
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  create_table "pictures", :force => true do |t|
    t.string   "name"
    t.integer  "revision_id"
    t.integer  "project_id"
    t.string   "original_image_url"
    t.string   "index_image_url"
    t.string   "revision_image_url"
    t.string   "display_image_url"
    t.integer  "original_image_size"
    t.integer  "index_image_size"
    t.integer  "revision_image_size"
    t.integer  "display_image_size"
    t.boolean  "is_deleted",           :default => false
    t.boolean  "is_selected",          :default => false
    t.boolean  "is_original",          :default => false
    t.boolean  "is_approved"
    t.integer  "approved_revision_id"
    t.integer  "original_id"
    t.integer  "score",                :default => 0
    t.integer  "user_id"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.integer  "width"
    t.integer  "height"
    t.string   "article_image_url"
    t.integer  "article_image_size"
    t.text     "assembly_url"
    t.boolean  "is_completed",         :default => true
  end

  create_table "polled_deliveries", :force => true do |t|
    t.boolean  "is_delivered",                 :default => false
    t.string   "recipient_email"
    t.integer  "user_activity_id"
    t.time     "notification_raised_time"
    t.datetime "notification_raised_datetime"
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
  end

  create_table "positional_comments", :force => true do |t|
    t.integer  "comment_id"
    t.integer  "x_start"
    t.integer  "y_start"
    t.integer  "x_end"
    t.integer  "y_end"
    t.integer  "picture_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "project_assignments", :force => true do |t|
    t.integer  "project_membership_id"
    t.integer  "project_role_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  create_table "project_memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "project_roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "projects", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "owner_id"
    t.integer  "picture_select_quota"
    t.boolean  "is_private",           :default => false
    t.boolean  "is_locked",            :default => false
    t.integer  "company_id"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.boolean  "done_with_selection",  :default => false
    t.boolean  "is_finalized",         :default => false
  end

  create_table "revisionships", :force => true do |t|
    t.integer  "picture_id"
    t.integer  "revision_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_activities", :force => true do |t|
    t.string   "subject_type"
    t.string   "actor_type"
    t.string   "secondary_subject_type"
    t.integer  "subject_id"
    t.integer  "actor_id"
    t.integer  "secondary_subject_id"
    t.boolean  "is_notification_sent",   :default => false
    t.integer  "event_type"
    t.integer  "project_id"
    t.integer  "actor_role_id"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
