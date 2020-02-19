class Category
  
  attr_accessor :category
  
  @@category_all = []
  
  def initialize(cat)
    @category = cat 
    @@category_all << self
  end
  
  def self.all 
    @@category_all
  end 
  
  def self.find_category(name)
    @@category_all.select{|a| a.category == name}
  end
  
  def self.search_categories(c)
    t = @@category_all.find{|a| a.category == c}
    if t = nil 
      category = Category.new(c) 
    else
       category = t
    end
    category 
    binding.pry
  end 
  
  def self.get_top_topics
    arr = Scraper.scrape_top_topics
  end 
end 
