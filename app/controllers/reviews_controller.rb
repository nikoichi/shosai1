class ReviewsController < ApplicationController
  def new
    @book = Book.find(params[:book_id])
    @review = Review.new
  end

  def create
    Review.create(create_params)
    redirect_to controller: :books, action: :index # トップページにリダイレクトする
  end

  private
  def create_params
    params.require(:review).permit(:verall_rate, :change_life_rate, :learning_rate, :sympathy_rate, :interesting_rate, :impression_rate, :under_elementary_school_age_rate, :junior_high_school_student_rate, :igh_school_student_rate, :university_student_rate, :younger_20s_rate, :in_30s40s_rate, :in_50s60s_rate, :after_retirement_rate, :review_title, :review,)
    .merge(book_id:params[:book_id])
  end
end
