require_relative 'hangman_art'
require 'yaml'

@game_word
@word_array = []
@display_word = []
@player_input
@mistakes = 0
@guessed_letter = []
@winning = false

def intro
    puts "Welcome to the Hangman game! Can you guess the mystery word before it's too late?"
    puts "You can save your progress at any time during the game by typing 'save'."
    puts HANGMAN_ART[0]
end

def select_word
    text_file = File.readlines('text/filtered_text.txt')
    text_file = text_file.map(&:chomp)
    @game_word = text_file.sample.upcase
end

def draw_starting_clue
    puts ''
    @word_array = @game_word.chars
    # p @word_array
    @word_array.length.times do 
        @display_word << '_ '     
    end 
    puts @display_word.join
end

def ask_player
    loop do
        puts ''
        print 'Enter your guess: '
        @player_input = gets.upcase.chomp
        if @player_input == 'SAVE'
            save_game
            exit
        elsif @player_input.match?(/^[A-Za-z]$/) 
            break
        else 
            puts "Invalid input. Please enter a single letter."
        end
    end
end

def correct_guess
    @word_array.map.with_index do |letter, index|
        if letter == @player_input
            @display_word[index] = "#{@player_input} "
        end
    end
    puts @display_word.join
end

def incorrect_guess
    puts HANGMAN_ART[@mistakes]
end

def check_answer
    if @guessed_letter.map.include?(@player_input)
        puts "You've guessed this letter before."
        return
    else 
        @guessed_letter << @player_input
    end

    if @word_array.map.include?(@player_input)
        puts "Yes! #{@player_input} is in the word."
        correct_guess
    else
        @mistakes += 1
        puts "Sorry, #{@player_input} is not in the word."
        incorrect_guess
    end
end

def check_winning
    @winning = (@display_word.join.delete(' ') == @word_array.join)
end

def save_game
    game_state = {
        winning: @winning,
        game_word: @game_word,
        word_array: @word_array,
        display_word: @display_word,
        mistakes: @mistakes,
        guessed_letter: @guessed_letter
    }

    File.open("save_game.txt", "w") do |file|
        file.write(game_state.to_yaml)
    end

    puts "Game saved successfully!"
end

def load_game
    loaded_game_state = YAML.load_file("save_game.txt")

    @winning = loaded_game_state[:winning]
    @game_word = loaded_game_state[:game_word]
    @word_array = loaded_game_state[:word_array]
    @display_word = loaded_game_state[:display_word]
    @mistakes = loaded_game_state[:mistakes]
    @guessed_letter = loaded_game_state[:guessed_letter]
end


def play_game
    while !@winning && @mistakes < 6
        ask_player
        check_answer
        check_winning
    end
    
    if @winning
        puts "Well done! You've won the game!"
    else @mistakes == 6
        puts "Sorry, you ran out of guesses. The word was #{@game_word}."
    end
end

def start_game_without_save
    intro
    select_word
    draw_starting_clue
    play_game 
end

def start_game_with_save
    puts HANGMAN_ART[@mistakes]
    puts "Previously you have made #{@mistakes} mistakes."
    puts "You have guessed these letters: #{@guessed_letter.join(' ')}"
    puts "#{@display_word.join(' ')}"
    play_game
end

def load_save_file
    puts "Would you like to load a save file? (yes/no)"
    response = gets.chomp.downcase

    if response == "yes" || response == "y" 
        if File.exist?("save_game.txt")
            load_game
            start_game_with_save
        else
            puts "Save file does not exist. Starting a new game ..."
            start_game_without_save
        end
    elsif response == "no" || response == "n" 
        start_game_without_save
    else
        puts "Invalid response. Please enter 'yes' or 'no'."
    end
end

load_save_file

