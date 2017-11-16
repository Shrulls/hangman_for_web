require "json"
require "sinatra"
require "erb"

require "./board.rb"

enable :sessions

#def play_loop
#    game = Board.new
#    save_file = "savedGames.txt"
#
#    puts "Welcome to Hangman!"
#    while !game.finished? && game.remaining_guesses >= 0 do
#        puts "Your guess: #{game.guess}"
#        puts "Already guessed: #{game.wrong_chars}"
#        puts "Remaining guesses: #{game.remaining_guesses}"
#        print "Enter a letter: "
#        character_guess = gets.chomp
#        if !game.makeGuess(character_guess)
#            game.incorrect_letters(character_guess)
#        end
#        puts
#    end
#end
    
def save_game(game)
    print "Save as: "
    name = gets.chomp
    
    #Adds name to save list
    file = File.open(save_file, "a")
    file.puts name
    file.close
    
    #Save the file
    name += ".txt"
    file = File.open(name, "w")
    file.puts game.to_json
    file.close
end

def load_game
    save_file = "savedGames.txt"
    file = File.open(save_file, "r")
    contents = file.read
    data = JSON.load contents
    count = data['count']
    files = data['files']
    puts count
    puts files
end

def validate_guess(guess)
    if [*'a'..'z'].include? guess.downcase
        return true
    else
        return false
    end
end

game = Board.new

get '/' do
    @message = "Enter a guess:"
    @guess = game.guess
    @incorrect_letters = game.wrong_chars
    @remaining_guesses = game.remaining_guesses
    erb :hangman
end

post '/guess' do
    if validate_guess(params[:letter])
        if !game.makeGuess(params[:letter])
            game.incorrect_letters(params[:letter])
        end
        @message = "Enter a guess:"
    else
        @message = "Please enter a letter a-z"
    end
    @guess = game.guess
    @incorrect_letters = game.wrong_chars
    @remaining_guesses = game.remaining_guesses
    erb :hangman
end

