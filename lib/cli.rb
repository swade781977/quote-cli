class CLI 
  
  def call 
    CLI.main_menu 
  end
  
  def self.main_menu 
    puts
    puts
    puts
    puts "       ----------------------------------------------".colorize(:yellow)
    puts
    puts "                        Qoutes!  ".colorize(:yellow)
    puts
    puts "       ----------------------------------------------".colorize(:yellow)
    puts
    puts
    puts "       ----------------------------------------------".colorize(:cyan)
    puts
    puts "                       Main Menu                     ".colorize(:cyan)
    puts "       ----------------------------------------------".colorize(:cyan)
    puts
    puts "       1. Browse authors alphabetically.".colorize(:yellow)
    puts "       2. View a random list of top authors to select from.".colorize(:yellow)
    puts "       3. Browse by topic".colorize(:yellow)
    puts "       4. View a random list of top topics to select from".colorize(:yellow)
    puts 
    puts
    puts "        Please choose a number 1-4".colorize(:green)
    puts "        Youcan type exit at any time to exit the program.".colorize(:green)
    
    while true 
      input = gets.chomp!
      if input == "exit"
        puts "Thank's for visiting. Good bye.".colorize(:magenta)
        exit!
      elsif input.to_i > 0 && input.to_i < 5
        @input = input.to_i
      else
        puts "Please enter a valid number or type exit.".colorize(:magenta)
      end
      case @input
      when 1
        letter = CLI.choose_letter
        CLI.display_authors_by_letter(letter, start= 0, stop= 24)
      when 2
        CLI.random_list_of_top_authors
      when 3
        CLI.browse_by_topic
      when 4 
        CLI.random_top_topics
      end
    end
  end
  
  def self.display_authors_by_letter(letter, start = 0, stop = 24)
    authors_list = Author.get_authors_by_letter(letter)
    answer = 1
    start = 0 
    stop = 24
    error_holder = ''
    while answer == 1 
      authors_list[start..stop].each_with_index do |author, index|
        puts "#{index + 1}| #{author.name}"
      end
      puts 
      puts error_holder
      puts "Enter 1 to select the author and see quotes from that author.".colorize(:green)
      puts "Enter 2 for the next 25 authors.".colorize(:green)
      puts "Enter 3 to go back to the previous screen.".colorize(:green)
      puts "Enter exit to exit the program.".colorize(:green)
      input = gets.downcase.strip!
      if input == "exit"
        puts "Thank's for visiting. Good bye.".colorize(:magenta)
        exit!
        elsif input.to_i > 0 && input.to_i <= 5 
          @input = input.to_i
        else
          puts = "Please enter a valid number or type exit."
        end
        case @input
        when 1 
          puts "Enter author number."
          a = gets.strip!.to_i
          author = authors_list[start + a - 1].name
          CLI.display_quotes_by_author(author)
        when 2 
          if stop > authors_list.count
            error_holder = "Please make a different selection."
            answer = 1
          else
            start += 25
            stop += 25
            answer = 1 
          end
        when 3 
          if start == 0 
            letter = CLI.choose_letter
            CLI.display_authors_by_letter(letter)
          else
            start -= 25 
            stop -= 25
            answer = 1 
          end
        when 4 
          letter = CLI.choose_letter
          CLI.display_authors_by_letter(letter)
        when 5 
          CLI.main_menu
        end
      end
    end
    
    def self.choose_letter
      puts "                            Please choose a letter."
      puts
      puts "              A | B | C | D | E | F | G | H | I | J | K | L | M |"
      puts "              N | O | P | Q | R | S | T | U | V | W | X | Y | Z |"
      letter = gets.downcase.strip!
    end
    
    def self.display_quotes_by_author(author, start = 0, stop = 9)
      quotes_list = Scraper.scrape_quotes_by_author(author)
      answer = 1 
      start = 0 
      stop = 9
      error_holder = ''
      while answer == 1 
        quotes_list[start..stop].each_with_index do |quote, index|
          puts "#{index + 1}"
          puts "#{quote.quote}"
          puts 
          puts "#{quote.get_author(quote)}"
          puts "Categories".colorize(:yellow)
          quote.get_categories(quote).each_with_index{|item, index| puts "#{index + 1}| #{item.category}"}
          puts "____________________________________________________________________________"
        end
        puts
        puts  error_holder
        puts "Enter 1 to select a category from a particular quote.".colorize(:green)
        puts "Enter 2 for the next 10 quotes.".colorize(:green)
        puts "Enter 3 to go back to the previous screen.".colorize(:green)
        puts "Enter 4 to browse another letter.".colorize(:green)
        puts "Enter 5 to go back to the main menu".colorize(:green)
        input = gets.downcase.strip!
        if input == "exit"
          puts "Thanks for visiting. Good bye.".colorize(:magenta)
          exit!
        elsif input.to_i > 0 && input.to_i <= 5 
          @input = input.to_i
        else
          puts "Please enter a valid number or type exit."
        end
        case @input
        when 1
          puts "Enter quote number."
          a = gets.strip!.to_i
          puts "Enter category number from thoe quote."
          b = gets.strip!.to_i
          q = quotes_list[a - 1]
          top = q.categories[b - 1]
          CLI.display_quotes_by_category(top)
        when 2
          if stop + 10 > quotes_list.count
            error_holder = "You've reached the end of the list!".colorize(:magenta)
            error_holder
            answer = 1 
          else
            start += 10
            stop += 10
            answer = 1
          end
        when 3
          if start == 0
            CLI.main_menu
          else
            start -= 10
            stop -= 10
            answer = 1
          end
        when 4 
          letter = CLI.choose_letter
          CLI.display_authors_by_letter(letter)
        when 5 
          CLI.main_menu
        end
        answer
      end
    end
    
    def self.display_quotes_by_category(topic, start = 0, stop = 9)
      topic_name = topic.category
      quotes_list = Scraper.scrape_quotes_by_topic(topic_name)
      answer = 1
      start = 0
      stop = 9
      error_holder = ''
      while answer == 1
      quotes_list[start..stop].each_with_index do |quote, index|
        puts "#{index + 1}"
        puts "#{quote.quote}"
        puts
        puts "#{quote.author.name}"
        puts "Categories:"
        quote.categories.each_with_index{|item, index| puts "#{index + 1}| #{item.category}"}
        puts "_________________________________________________________________________"
      end 
      puts
      puts error_holder
      puts "Enter 1 to select a category from a particular quote.".colorize(:green)
      puts "Enter 2 for the next 10 quotes.".colorize(:green)
      puts "Enter 3 to go back to the previous screen.".colorize(:green)
      puts "Enter 4 to go back to the main menu.".colorize(:green)
      puts "Enter exit to exit the program.".colorize(:green)
      input = gets.downcase.strip!
      if input == "exit"
        puts "Thanks for visiting. Good bye.".colorize(:magenta)
        exit!
      elsif input.to_i > 0 && input.to_i < 5
        @input = input.to_i
      else 
        puts "Please enter a valid number or type exit."
      end
      case @input 
      when 1 
        puts "Enter quote number."
        a = gets.strip!.to_i
        puts "Enter category number from the quote."
        b = gets.strip!.to_i
        q = quotes_list[a - 1]
        top = q.categories[b - 1]
        CLI.display_quotes_by_category(top)
      when 2 
        if stop + 10 > quotes_list.count
          error_holder = "You've reached the end of the list!".colorize(:magenta)
          error_holder
          answer = 1 
        else 
          start += 10
          stop += 10
          answer = 1
        end
      when 3
        if 
          start == 0 
          CLI.main_menu
        else
          start -= 10
          stop -= 10
          answer = 1
        end
      when 4 
        CLI.main_menu
      end
    end
  end
  
  def self.random_top_topics
    topics_arr = Scraper.scrape_top_topic
    answer = 1 
    while answer == 1
      rand_top_topics = topics_arr.sample(10)
      rand_top_topics.each_with_index do |topic, index|
        puts "#{index + 1}| #{topic.category}"
      end
    puts
    puts "Enter 1 to select a category you would like to see quotes from.".colorize(:green)
    puts "Enter 2 to Spin Again!".colorize(:green)
    puts "Enter 3 to go back to the main menu.".colorize(:green)
    puts "Enter exit to exit the program.".colorize(:green)
    input = gets.downcase.strip!
    if input == "exit"
      puts "Thanks for visiting. Good bye.".colorize(:magenta)
      exit! 
    elsif input.to_i > 0 && input.to_i < 5 
      @input = input.to_i
    else
      puts "Please enter a valid number or type exit."
    end
    case @input
    when 1 
      puts "Enter category number."
      num = gets.to_i
      c = rand_top_topics[num - 1]
      CLI.display_quotes_by_category(c)
    when 2
      answer = 1 
    when 3
      CLI.main_menu
    end
  end
end
  def self.random_list_of_top_authors
    authors_list = Scraper.scrape_top_authors
    answer = 1 
    while answer == 1
      rand_top_authors = authors_list.sample(25)
      rand_top_authors.each_with_index do |author, index|
        puts "#{index + 1}| #{author.name}"
      end
    puts
    puts "Enter 1 to select an author you would like to see quotes from.".colorize(:green)
    puts "Enter 2 to Spin Again!".colorize(:green)
    puts "Enter 3 to go back to the main menu.".colorize(:green)
    puts "Enter exit to exit the program.".colorize(:green)
    input = gets.downcase.strip!
    if input == "exit"
      puts "Thanks for visiting. Good bye.".colorize(:magenta)
      exit! 
    elsif input.to_i > 0 && input.to_i < 5 
      @input = input.to_i
    else
      puts "Please enter a valid number or type exit."
    end
    case @input
    when 1 
      puts "Enter author number."
      a = gets.strip!.to_i
      author = rand_top_authors[a - 1]
      CLI.display_quotes_by_author_for_2(author)
    when 2
      answer = 1 
    when 3
      CLI.main_menu
    end
  end
end

  def self.browse_by_topic
    topics_arr = Scraper.scrape_top_topic
    start = 0 
    stop = 24
    answer = 1
    error_holder = ""
    while answer == 1 
      topics_arr[start..stop].each_with_index do |topic, index|
        puts "#{index + 1}| #{topic.category}"
      end
       puts 
      puts error_holder
      puts "Enter 1 to select the category and see quotes from that category.".colorize(:green)
      puts "Enter 2 for the next 25 categories.".colorize(:green)
      puts "Enter 3 to go back to the previous screen.".colorize(:green)
      puts "Enter 4 to go back to the main menu.".colorize(:green)
      puts "Enter exit to exit the program.".colorize(:green)
      input = gets.downcase.strip!
      if input == "exit"
        puts "Thank's for visiting. Good bye.".colorize(:magenta)
        exit!
        elsif input.to_i > 0 && input.to_i <= 5 
          @input = input.to_i
        else
          puts = "Please enter a valid number or type exit."
        end
        case @input
        when 1 
          puts "Enter category number."
          a = gets.strip!.to_i
          category = topics_arr[start + a - 1]
          CLI.display_quotes_by_category(category)
        when 2 
          if stop > topics_arr.count
            error_holder = "You've reached the end of the list!".colorize(:magenta)
            answer = 1
          else
            start += 25
            stop += 25
            answer = 1 
          end
        when 3 
          if start == 0 
            answer = 1
          else
            start -= 25 
            stop -= 25
            answer = 1 
          end
        when 4 
          CLI.main_menu
        end
      end
    end
    
    def self.display_quotes_by_author_for_2(author, start = 0, stop = 9)
      quotes_list = Scraper.scrape_quotes_by_author_for_2(author)
      answer = 1 
      start = 0 
      stop = 9
      error_holder = ''
      while answer == 1 
        quotes_list[start..stop].each_with_index do |quote, index|
          puts "#{index + 1}"
          puts "#{quote.quote}"
          puts 
          puts "#{quote.author.name}"
          puts "Categories".colorize(:yellow)
          quote.categories.each_with_index{|item, index| puts "#{index + 1}| #{item.category}"}
          puts "____________________________________________________________________________"
        end
        puts
        puts  error_holder
        puts "Enter 1 to select a category from a particular quote.".colorize(:green)
        puts "Enter 2 for the next 10 quotes.".colorize(:green)
        puts "Enter 3 to go back to the previous screen.".colorize(:green)
        puts "Enter 4 to browse another letter.".colorize(:green)
        puts "Enter 5 to go back to the main menu".colorize(:green)
        input = gets.downcase.strip!
        if input == "exit"
          puts "Thanks for visiting. Good bye.".colorize(:magenta)
          exit!
        elsif input.to_i > 0 && input.to_i <= 5 
          @input = input.to_i
        else
          puts "Please enter a valid number or type exit."
        end
        case @input
        when 1
          puts "Enter quote number."
          a = gets.strip!.to_i
          puts "Enter category number from thoe quote."
          b = gets.strip!.to_i
          q = quotes_list[a - 1]
          top = q.categories[b - 1]
          CLI.display_quotes_by_category(top)
        when 2
          if stop + 10 > quotes_list.count
            error_holder = "You've reached the end of the list!".colorize(:magenta)
            error_holder
            answer = 1 
          else
            start += 10
            stop += 10
            answer = 1
          end
        when 3
          if start == 0
            CLI.main_menu
          else
            start -= 10
            stop -= 10
            answer = 1
          end
        when 4 
          letter = CLI.choose_letter
          CLI.display_authors_by_letter(letter)
        when 5 
          CLI.main_menu
        end
        answer
      end
    end
      
end