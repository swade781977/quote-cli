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
  
  def self.search_categories(category)
    t = @@category_all.find{|a| a.category == category}
    if t != nil 
      category = t
    else
      category = Category.new(category)
    end
    category
  end
  
  def self.get_top_topics
    arr = Scraper.scrape_top_topics
  end
end

