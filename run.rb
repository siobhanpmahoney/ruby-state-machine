require_relative './Ellevest'

def cli_interface
  welcome
  input = ""
  while input != "exit"
    input = start_flow
    if input == "status?"
      puts "-----------------------------------------------------------------------------"
      puts print_article_status(@a)
    elsif input == "options"
      puts "-----------------------------------------------------------------------------"
      # puts @a.status.methods - Object.methods
      puts get_options(@a)
    elsif input.start_with?("command:")
      puts "-----------------------------------------------------------------------------"
      @a.update_status(@a, input.split(": ")[1])
      puts "Article's status has been updated to: #{print_article_status(@a)}"
      puts "Availble actions include: #{get_options(@a)}"
    elsif input == "help"
      puts "-----------------------------------------------------------------------------"
      help
    end
  end
  puts "-----------------------------------------------------------------------------"
  puts "Goodbye"
end

def welcome
  puts "Welcome to the Ruby State Machine!"
  puts "A new Article was created:"
  create_article
  puts @a
  help
end

def start_flow
  puts "-----------------------------------------------------------------------------"
  gets.chomp
end

def help
  puts "To see current status, enter 'status?'"
  puts "To see current action options, enter 'options'"
  puts "To run action command, enter 'command: [ACTION]'"
  puts "To exit, enter 'exit'"
  puts "To see these options, enter 'help'"
end

def user_input
  input = gets.chomp
  input
end


def create_article
  @a = Article.new()
end

def get_options(a)
  (a.status.methods - Object.methods).select do |op|
    op != :update_status
  end
end





def print_article_status(article)
  article.status.class.to_s.split("::")[1]
end





cli_interface
