class BooksController < ApplicationController

  def index
    @recommendation_new_books = Book.includes(:reviews).limit(20).shuffle[0..4] #新着好評価(高評価上位20冊から5冊を表示)
    @recommendation_new_books_rate_averages = set_rate_ave(@recommendation_new_books) #新着好評価5冊の平均値を取得。
    @recommendation_all_books = Book.includes(:reviews).limit(20).shuffle[0..4] #すべての本の高評価
    @recommendation_all_books_rate_averages = set_rate_ave(@recommendation_all_books) #5冊の平均値を取得。
    @recommendation_generation_books = Book.includes(:reviews).limit(20).shuffle[0..4] #世代別高評価
    @recommendation_generation_books_rate_averages = set_rate_ave(@recommendation_generation_books) #5冊の平均値を取得。
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
    @books = Book.includes(:reviews).where('book_title LIKE(?)', "%#{params[:keyword]}%").page(params[:page]).per(10)
    #以下、検索結果件数表示
    set_paginate_values(@books)
    set_ave_arrays(@books)
  end

  def ranking
    book_ids = Review.group(:book_id).order('average_overall_rate DESC').average(:overall_rate).keys
    @books = book_ids.map{|id| Book.find(id)}.page(params[:page]).per(10)
    #以下、検索結果件数表示
    set_paginate_values(@books)
    set_ave_arrays(@books)
  end

  #各本のレート平均値を取得し、ハッシュの配列を返す。
  def set_rate_ave(books)
    averages = []
    books.each do |book|
      averages << {:ave_value => rate_ave_value(book.reviews.where.not("overall_rate" => 0).average(:overall_rate)), :ave_star => rate_ave_star(book.reviews.where.not("overall_rate" => 0).average(:overall_rate))}
    end
    return averages
  end

  def set_paginate_values(books)
    @number = Book.where('book_title LIKE(?)', "%#{params[:keyword]}%").length  #検索件数を取得
    @page = params[:page].to_i
    @page = 1 if books.first_page? #1ページのみparams[:page]がnilとなるので、最初のページの場合は1となるようにした。
    @view_start_num = (@page-1)*10 + 1
    @view_end_num = @page*10
    @view_end_num = @number if books.last_page?  #最後のページは検索件数まで表示
  end

  #全ての本において平均を配列で取得するための処理を実施。
  def set_ave_arrays(books)
    if books
      @fundamental_rate_ave_values_array = []
      @fundamental_rate_ave_stars_array = []
      @genetation_rate_ave_values_array = []
      @generation_rate_ave_stars_array = []
      @myreviews = []

      books.each do |book|
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

end
