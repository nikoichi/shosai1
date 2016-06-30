# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require "csv"

books_csv = CSV.readlines("db/books.csv")
books_csv.shift
books_csv.each do |row|
  Book.create(book_title: row[1], book_img_url: row[2], amazon_detail_url: row[3], publication_date: row[4], created_at: row[5], updated_at: row[6])
end

users_csv = CSV.readlines("db/users.csv")
users_csv.shift
users_csv.each do |row|
  User.create(email: row[1], encrypted_password: row[2], reset_password_token: row[3], reset_password_sent_at: row[4], remember_created_at: row[5], sign_in_count: row[6], current_sign_in_at: row[7], last_sign_in_at: row[8], current_sign_in_ip: row[9], last_sign_in_ip: row[10], created_at: row[11], updated_at: row[12], avatar_file_name: row[13], avatar_content_type: row[14], avatar_file_size: row[15], avatar_updated_at: row[16], nickname: row[17])
end

reviews_csv = CSV.readlines("db/reviews.csv")
reviews_csv.shift
reviews_csv.each do |row|
  Review.create(book_id: row[1], user_id: row[2], read_state: row[3], finish_reading_date: row[4], review_title: row[5], review: row[6], impression_phrase: row[7], book_report: row[8], overall_rate: row[9], change_life_rate: row[10]c, learning_rate: row[11], sympathy_rate: row[12], interesting_rate: row[13], impression_rate: row[14], under_elementary_school_age_rate: row[15], junior_high_school_student_rate: row[16], high_school_student_rate: row[17], university_student_rate: row[18], younger_20s_rate: row[19], in_30s40s_rate: row[20], in_50s60s_rate: row[21], after_retirement_rate[22], created_at: row[23], updated_at: row[24])
end
