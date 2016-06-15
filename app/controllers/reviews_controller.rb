class ReviewsController < ApplicationController
  def new
    @book = Book.find(params[:book_id])
    @review = Review.new
  end

  def create
    # Review.create(create_params)
    redirect_to controller: :books, action: :index # トップページにリダイレクトする
  end
end
