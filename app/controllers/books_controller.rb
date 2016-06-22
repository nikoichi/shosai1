class BooksController < ApplicationController

  def index
    @recommendation_new_books = Book.limit(20).shuffle[0..4] #新着好評価(高評価上位20冊から5冊を表示
    @recommendation_all_books = Book.limit(20).shuffle[0..4] #すべての本の高評価
    @recommendation_generation_books = Book.limit(20).shuffle[0..4] #世代別高評価
  end

  def show
    @book = Book.find(params[:id])
    @reviews = Review.includes(:user).where(book_id: params[:id]).order(updated_at: :desc)#レビューを編集の最新順に表示されるように並び替え
    if user_signed_in? #サインインしている場合のみ@myreviewにセット。
      @myreview = Review.find_by(book_id: params[:id], user_id: current_user.id)
    end
  end

  def search
    @books = Book.where('book_title LIKE(?)', "%#{params[:keyword]}%").limit(20)
  end
end
