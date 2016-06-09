class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string  :book_title
      t.text  :book_img_url
      t.text  :amazon_detail_url
      t.date  :publication_date
      t.timestamps
    end
  end
end
