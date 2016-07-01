class BooksController < ApplicationController

  def index
    @recommendation_new_books = Book.includes(:reviews).limit(20).shuffle[0..4] #新着好評価(高評価上位20冊から5冊を表示)
    @recommendation_new_books_rate_averages = set_rate_ave(@recommendation_new_books) #新着好評価5冊の平均値を取得。
    @recommendation_all_books = Book.includes(:reviews).limit(20).shuffle[0..4] #すべての本の高評価
    @recommendation_all_books_rate_averages = set_rate_ave(@recommendation_all_books) #5冊の平均値を取得。
    @recommendation_generation_books = Book.includes(:reviews).limit(20).shuffle[0..4] #世代別高評価
    @recommendation_generation_books_rate_averages = set_rate_ave(@recommendation_generation_books) #5冊の平均値を取得。
    # binding.pry
  end

  def show
    @book = Book.find(params[:id])
    @reviews = Review.includes(:user).where(book_id: params[:id]).order(updated_at: :desc)#レビューを編集の最新順に表示されるように並び替え
    set_rate_ave_hashs(@reviews) #各評価の平均値のハッシュを取得。
    if user_signed_in? #サインインしている場合のみ@myreviewにセット。
      @myreview = Review.find_by(book_id: params[:id], user_id: current_user.id)
    end
  end

  def search
    @books = Book.includes(:reviews).where('book_title LIKE(?)', "%#{params[:keyword]}%").limit(20)
    if @books
      @fundamental_rate_ave_values_array = []
      @fundamental_rate_ave_stars_array = []
      @genetation_rate_ave_values_array = []
      @generation_rate_ave_stars_array = []
      @myreviews = []

      @books.each do |book|
        set_rate_ave_hashs(book.reviews)
        @fundamental_rate_ave_values_array << @fundamental_rate_ave_values
        @fundamental_rate_ave_stars_array << @fundamental_rate_ave_stars
        @genetation_rate_ave_values_array << @genetation_rate_ave_values
        @generation_rate_ave_stars_array << @generation_rate_ave_stars
        if user_signed_in? #サインインしていてレビューを書いている場合に@myreviewにセット。その他はnil。
          @myreview = Review.find_by(book_id: book.id, user_id: current_user.id)
        else
          @myreview = nil
        end
        @myreviews << @myreview
      end
    end
  end

  #各本のレート平均値を取得し、ハッシュの配列を返す。
  def set_rate_ave(books)
    averages = []
    books.each do |book|
      averages << {:ave_value => rate_ave_value(book.reviews.where.not("overall_rate" => 0).average(:overall_rate)), :ave_star => rate_ave_star(book.reviews.where.not("overall_rate" => 0).average(:overall_rate))}
    end
    return averages
  end
end
