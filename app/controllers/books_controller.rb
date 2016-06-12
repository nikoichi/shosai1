class BooksController < ApplicationController

  def index
    @recommendation_books_new = Book.limit(20).shuffle[0..4]
    # binding.pry
    @recommendation_books_all = Book.limit(20).shuffle[0..4]
    @recommendation_books_generation = Book.limit(20).shuffle[0..4]
  end

  def show
    @book = Book.find(params[:id])
  end

  def search
    @books = Book.where('book_title LIKE(?)', "%#{params[:keyword]}%").limit(20)
  end
end
