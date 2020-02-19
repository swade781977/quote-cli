class Scraper
  
  def self.scrape_author_by_letter(letter)
    base_html = "http://www.brainyquote.com"
    puts "Gathering letter #{letter.upcase}"
    scrape_page = base_html + "/authors/#{letter}"
    page1 = Nokogiri::HTML(open(scrape_page))
    num_pages = page1.css('li a')[-5].text 
    num_pages = num_pages.to_i 
    page1.css('tbody tr').each do |item|
      name = item.css('a').text 
      author = Author.search_authors(name)
      href = item.css('a').attr('href').value
      author.page = base_html + href
    end
    num = 2..num_pages 
    num.each do |num| 
      scrape_page = base_html + "/authors/#{letter}#{num}"
      page = Nokogiri::HTML(open(scrape_page))
      page.css('tbody tr').each do |item|
        name = item.css('a').text
        author = Author.search_authors(name)
        href = item.css('a').attr('href').value
        author.page = base_html + href
      end
    end
  end
  
  def self.scrape_quotes_by_author(author)
    quotes = []
    scribe = Author.all.find{|a| a.name == author}
    binding.pry
    page = Nokogiri::HTML(open(scribe.page))
    page.css('.m-brick').each do |block|
      category = []
      category_temp = []
      quote1 = block.css('a')[0].text
      quote = Quote.search_quotes(quote1)
      quotes << quote
      author1 = block.css('a')[1].text
      author = Author.search_authors(author1)
      quote.author = author
      block.css('.kw-box').css('a').each do |c|
        a = Category.new(c.text)
        category << a
      end
      quote.categories = category
    end
    quotes
    
  end
  
  def self.scrape_quotes_by_topic(topic)
    quotes = []
    topic1 = topic.downcase
    topic2 = topic1.gsub(/ /, "-")
    topic3 = topic2.gsub(/'/, "")
    topic_page = "http://brainyquote.com/topics/#{topic3}-quotes"
    page = Nokogiri::HTML(open(topic_page))
    page.css('.m-brick').each do |block|
      category = []
      category_temp = []
      quote1 = block.css('a')[0].text
      quote = Quote.search_quotes(quote1)
      quotes << quote
      author1 = block.css('a')[1].text
      author = Author.search_authors(author1)
      quote.author = author
      block.css('.kw-box').css('a').each do |c|
        t = Category.new(c.text)
        category << t
      end
      quote.categories = category
    end
    quotes
  end
  
  def self.scrape_top_topic
    top_topics = []
    top_topics_temp = []
    topic_page = "http://www.brainyquote.com/topics"
    page = Nokogiri::HTML(open(topic_page))
    page.css('.bqLn').css('a').each do |f|
      t = Category.new(f.text.strip!)
      top_topics_temp << t
    end 
    top_topics_temp.each do |n|
      if n.category != nil
        top_topics << n 
      end
    end
    top_topics
  end
  
  def self.scrape_top_authors
    top_authors = []
    top_authors_temp = []
    base_html = "http://www.brainyquote.com"
    author_page = "http://www.brainyquote.com/authors"
    page = Nokogiri::HTML(open(author_page))
    page.css(".bqLn").css('a').each do |f|
      name = f.text
      a = Author.new(name)
      top_authors << a
      hr = f.attr('href')
      hr = hr.to_s
      a.page = base_html+hr
    end
    top_authors
  end
  
  def self.scrape_quotes_by_author_for_2(author)
    quotes = []
    page = Nokogiri::HTML(open(author.page))
    page.css('.m-brick').each do |block|
      category = []
      category_temp = []
      quote1 = block.css('a')[0].text
      quote = Quote.search_quotes(quote1)
      quotes << quote
      author1 = block.css('a')[1].text
      author = Author.search_authors(author1)
      quote.author = author
      block.css('.kw-box').css('a').each do |c|
        a = Category.new(c.text)
        category << a
      end
      quote.categories = category
    end
    quotes
  end
end