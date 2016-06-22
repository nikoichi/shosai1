class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: :new
  def new
    @book = Book.includes(:reviews).find(params[:book_id])
    # @review = Review.where(book_id: params[:book_id], user_id: current_user.id).first_or_initialize
    @review = Review.new
    # @myreview = []  #「レビューを書く」選択時に正しく条件分岐に入るために定義。
  end

  def create
    Review.create(create_params)
    redirect_to book_path(params[:book_id]) # 書籍ページ(show)にリダイレクトする
  end

   def edit
    @book = Book.includes(:reviews).find(params[:book_id])
    @review = Review.find(params[:id])
    @myreview = Review.find_by(book_id: params[:book_id], user_id: current_user.id)
   end

   def update
     Review.update(create_params)
     redirect_to book_path(params[:book_id]) # 書籍ページ(show)にリダイレクトする
   end

  private
  def create_params
    params.require(:review).permit(:overall_rate, :change_life_rate, :learning_rate, :sympathy_rate, :interesting_rate, :impression_rate, :under_elementary_school_age_rate, :junior_high_school_student_rate, :high_school_student_rate, :university_student_rate, :younger_20s_rate, :in_30s40s_rate, :in_50s60s_rate, :after_retirement_rate, :review_title, :review,)
    .merge(book_id: params[:book_id], user_id: current_user.id)
  end
end
