class Board
    
    attr_reader :remaining_guesses, :word
    
    def initialize(word="", guess=[], wrong_chars=[])
        @remaining_guesses = 10
        if word == ""
            @word = loadWord
            @guess = []
            @wrong_chars = []
            @word.length.times do
                @guess << "_"
            end
        else
            @guess = guess
            @word = word
            @wrong_chars = wrong_chars
            @remaining_guesses -= wrong_chars.length
        end
    end
    
    def loadWord
        lines = File.readlines "5desk.txt"
        r = Random.rand(lines.length)
        lines[r]
    end
    
    def makeGuess(letter)
        letter_in_word = false
        index = 0
        @word.each_char do |c|
            if c == letter
                @guess[index] = c
                letter_in_word = true
            end
            index += 1
        end
        letter_in_word
    end
    
    def finished?
        @word == @guess.join ? true : false
    end
    
    def guess
        @guess.flat_map {|x| [x, " "]}[0...-1].join
    end
    
    def incorrect_letters(letter)
        @wrong_chars << letter
        @remaining_guesses -= 1
    end
    
    def wrong_chars
        @wrong_chars.join(", ") 
    end
    
    def to_json
        JSON.dump({
            :guess => @guess,
            :word => @word,
            :wrong_chars => @wrong_chars
        })
    end
    
    def self.from_json(string)
        data = JSON.load string
        self.new(data['word'], data['guess'], data['wrong_chars'])
    end
        
end