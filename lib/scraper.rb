require 'nokogiri'
require 'open-uri'
require 'pry'

require_relative './quotes.rb'
require_relative './categories.rb'
require_relative './authors.rb'
require_relative './cli.rb'


class Scraper

  def self.scrape_author_by_letter(letter)
    base_html = "https://www.brainyquote.com"
    puts "Gathering letter #{letter}."
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
    
    scribe = Author.all.find{|a|  a.name == author}
    page = Nokogiri::HTML(open(scribe.page))
    page.css('.m-brick').each do |block|
      category = []
      category_temp = []
      quote1 = block.css('a')[0].text
      quote = Quote.search_quotes(quote1)
      author1 = block.css('a')[1].text
      author = Author.search_authors(author1)
      quote.author = author
      block.css('.kw-box').css('a').each do |c|
        category_temp << c.text
      end
      category_temp.each do |topic|
       c = Category.search_categories(topic)
       category << c
      end
      quote.categories = category
    end
  end

  def self.scrape_quotes_by_topic(topic)
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
      author1 = block.css('a')[1].text
      author = Author.search_authors(author1)
      quote.author = author
      block.css('.kw-box').css('a').each do |c|
        category = []
        cat = c.text
        category_temp << cat
        category_temp.each do |topic|
          c = Category.search_categories(topic)
          category << c
        end
      end
      quote.categories = category
    end
  end
  
  def self.scrape_top_topics
    top_topics = []
    top_topics_temp = []
    topic_page = "http://www.brainyquote.com/topics"
    page = Nokogiri::HTML(open(topic_page))
    page.css('.bqLn').css('a').each do |f|
      top_topics_temp << f.text.strip!
    end
    top_topics_temp.delete(nil)
    top_topics_temp.each do |topic|
      t = Category.search_categories(topic)
      top_topics << t
    end
    top_topics
  end
  
  def self.scrape_top_authors
    top_authors = []
    top_authors_temp = []
    author_page = "http://www.brainyquote.com/authors"
    page = Nokogiri::HTML(open(author_page))
    page.css(".authorContentName").each do |f|
      top_authors_temp << f.text
    end
    top_authors_temp.delete(nil)
    top_authors_temp.each do |author|
      t = Author.search_authors(author)
      top_authors << t
    end
    top_authors
  end
end
