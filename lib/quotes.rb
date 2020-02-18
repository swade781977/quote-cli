class Author 
  
  @@quotes_all = []

  attr_accessor :quote, :author, :categories 

  def initialize(quote)
  @quote = quote
  @@quotes_all << self
  end

  def self.all
    @@quotes_all 
  end

  
  def self.find_quote(quote)
    @@quotes_all.select{|a| a.quote == quote}
  end
  
  def self.search_quotes(quote)
      if @@quotes_all.include?(quote) == false 
        author = Quote.new(quote)
      else
        author = Quote.find_quote(quote)
      end
  end
  
end
