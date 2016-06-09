class Scraping
  def self.book_data(num)
    agent = Mechanize.new
    agent.user_agent_alias = 'Mac Safari'
    next_url = '/b/ref=s9_acss_bw_ct_category_ct3_a1?_encoding=UTF8&node=492216&pf_rd_m=AN1VRQENFRJN5&pf_rd_s=merchandised-search-7&pf_rd_r=0QEFH3623W1BHQ6ZV7W9&pf_rd_t=101&pf_rd_p=212081329&pf_rd_i=465610'
    i = 0

    while i < num do
      sleep(5)
      current_url = "http://www.amazon.co.jp/" + next_url
      current_page = agent.get(current_url)
      get_book(current_url) #本の情報をスクレイピング
      next_link = current_page.at('#pagnNextLink')
      next_url = next_link[:href]
      break unless next_url
      i += 1
    end
  end

  #現在のページの本(24冊?)の情報をスクレイピングし、booksテーブルに保存
  def self.get_book(link)
    agent = Mechanize.new
    agent.user_agent_alias = 'Mac Safari'
    page = agent.get(link)
    book_titles = page.search('.s-access-detail-page h2') if page.search('.s-access-detail-page h2')
    book_img_urls = page.search('.s-access-image') if page.search('.s-access-image')
    amazon_detail_urls = page.search('.s-access-detail-page') if page.search('.s-access-detail-page')
    # publication_dates = page.search('.s-item-container .a-spacing-mini .a-spacing-none .a-size-small') if page.search('.s-item-container .a-spacing-mini .a-spacing-none .a-size-small')

    book_titles.zip(book_img_urls, amazon_detail_urls).each do |book_title, book_img_url, amazon_detail_url|
      book = Book.where(book_title: book_title.inner_text).first_or_initialize
      book.book_img_url = book_img_url[:src]
      book.amazon_detail_url = amazon_detail_url[:href]
      book.save
    end
  end
end
