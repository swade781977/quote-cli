class Author
  
  @@all_authors = []
  
  attr_accessor :name, :page
  
  def initialize(name)
    @name = name
    @@all_authors << self
  end
  
  def self.all 
    @@all_authors
  end
  
  def self.find_author(name)
    @@all_authors.select{|a| a.name == name}
  end
  
  def self.search_authors(name)
    if @@all_authors.include?(name) == false 
      author = Author.new(name)
    else
      author = Author.find_author(name)
    end
  end 
  
  def self.find_authors_by_letter(letter)
    a = letter.upcase!
    arr = []
    @@all_authors.each do |author|
      if author.name.start_with? "#{letter}"
        arr << author
      end
    end
    arr
  end
  
  def self.get_authors_by_letter(letter)
    letter.downcase
    author_arr = []
    Scraper.scrape_author_by_letter(letter)
    author_arr = Author.find_authors_by_letter(letter)
    return author_arr
  end
  
  def self.get_top_authors
    arr = Scraper.scrape_top_authors
    arr
  end
end

