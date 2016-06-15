class CreateUserReadBooks < ActiveRecord::Migration
  def change
    create_table :user_read_books do |t|
      t.references  :book
      t.references  :user
      t.integer :read_state #読書状態
      t.date  :finish_reading_date  #読書完了日

      # レビュー関連
      t.string  :review_title
      t.text  :review
      t.text  :impressive_phrase
      t.text  :book_report

      # 基本評価
      t.integer :overall_rate
      t.integer :change_life_rate
      t.integer :learning_rate
      t.integer :sympathy_rate
      t.integer :interesting_rate
      t.integer :impression_rate

      # 世代別評価
      t.integer :under_elementary_school_age_rate
      t.integer :junior_high_school_student_rate
      t.integer :high_school_student_rate
      t.integer :university_student_rate
      t.integer :younger_20s_rate
      t.integer :in_30s40s_rate
      t.integer :in_50s60s_rate
      t.integer :after_retirement_rate
      
      t.timestamps
    end
  end
end
