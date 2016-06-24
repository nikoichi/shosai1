class BooksController < ApplicationController

  def index
    @recommendation_new_books = Book.includes(:reviews).limit(20).shuffle[0..4] #新着好評価(高評価上位20冊から5冊を表示)
    @recommendation_all_books = Book.includes(:reviews).limit(20).shuffle[0..4] #すべての本の高評価
    @recommendation_generation_books = Book.includes(:reviews).limit(20).shuffle[0..4] #世代別高評価
    # add_overall_rate_ave(@recommendation_new_books)
  end

  def show
    @book = Book.find(params[:id])
    @reviews = Review.includes(:user).where(book_id: params[:id]).order(updated_at: :desc)#レビューを編集の最新順に表示されるように並び替え
    set_rate_ave_arrays(@reviews) #各評価の平均値の配列を取得。
    if user_signed_in? #サインインしている場合のみ@myreviewにセット。
      @myreview = Review.find_by(book_id: params[:id], user_id: current_user.id)
    end
  end

  def search
    @books = Book.where('book_title LIKE(?)', "%#{params[:keyword]}%").limit(20)
  end

  def add_overall_rate_ave(books)
    books.each do |book|
      book[:ave_value] = rate_ave_value(book.reviews.average(:overall_rate)) #bookに新たなハッシュの要素:ave_valueを追加。
      book[:ave_star] = rate_ave_star(book.reviews.average(:overall_rate))
      # book[:ave_value] = ave_value
    end
  end
end
