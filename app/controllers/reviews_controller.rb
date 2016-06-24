class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: :new

  def new
    #既にレビューを書いている場合は編集画面へ遷移
    @myreview = Review.find_by(book_id: params[:book_id], user_id: current_user.id)
    if @myreview
      redirect_to edit_book_review_path(params[:book_id],myreview.id)
    else
      @reviews = Review.where(book_id: params[:book_id])
      @fundamental_rate_ave_values = rate_ave_values_array(@fundamental_rates, @reviews)
      @fundamental_rate_ave_stars = rate_ave_stars_array(@fundamental_rates, @reviews)
      @book = Book.includes(:reviews).find(params[:book_id])
      @review = Review.new
    end
  end

  def create
    Review.create(review_params)
    redirect_to book_path(params[:book_id]) # 書籍ページ(show)にリダイレクトする
  end

  def edit
    #レビューを書いていない場合はnewへリダイレクト
    @myreview = Review.find_by(book_id: params[:book_id], user_id: current_user.id)
    unless @myreview
      redirect_to new_book_review_path(params[:book_id])
    else
      @reviews = Review.where(book_id: params[:book_id])
      @fundamental_rate_ave_values = rate_ave_values_array(@fundamental_rates, @reviews)
      @fundamental_rate_ave_stars = rate_ave_stars_array(@fundamental_rates, @reviews)
      @book = Book.includes(:reviews).find(params[:book_id])
      @review = Review.find(@myreview.id)
    end
  end

  def update
    @review = Review.find(params[:id])
    @review.update(review_params)
    redirect_to book_path(params[:book_id]) # 書籍ページ(show)にリダイレクトする
  end

  def destroy
    @review = Review.find(params[:id])
    if @review.user_id == current_user.id
      @review.destroy
    end
    redirect_to book_path(params[:book_id])
  end

  private
    def review_params
      params.require(:review).permit(:overall_rate, :change_life_rate, :learning_rate, :sympathy_rate, :interesting_rate, :impression_rate, :under_elementary_school_age_rate, :junior_high_school_student_rate, :high_school_student_rate, :university_student_rate, :younger_20s_rate, :in_30s40s_rate, :in_50s60s_rate, :after_retirement_rate, :review_title, :review,)
      .merge(book_id: params[:book_id], user_id: current_user.id)
    end

end
