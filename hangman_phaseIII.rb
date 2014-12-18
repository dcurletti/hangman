class Game
  def initialize(guessing_player, checking_player)
    @guessing_player = guessing_player
    @checking_player = checking_player
  end

  def play
    secret_length = @checking_player.receive_secret_length
    print "Secret word: "
    # puts @checking_player.secret_word

    print "_ " * secret_length
    puts ""
    puts ""
    num_matched_locations = 0
    current_word = []

    until num_matched_locations == secret_length
      puts "num match locations: #{num_matched_locations} secret length: #{secret_length}"

      guess = @guessing_player.guess
      checked_guess = @checking_player.check_guess(guess)
      num_matched_locations, current_word = @checking_player.handle_guess_response(checked_guess, current_word)
    end
    puts ""
    puts "Great job, you won!"
  end
end

class ComputerPlayer

  attr_accessor :secret_word, :guess, :match_locations, :secret_word_length

  def initialize
    @dictionary = get_dictionary
    @secret_word = @dictionary.sample
    @secret_word_length = @secret_word.length
    @match_locations = []
    @current_word = []
  end

  def handle_guess_response(checked_guess, current_word)
    @current_word = current_word
    checked_guess.each do |location|
      unless @match_locations.include?(location)
        @match_locations += checked_guess
      end
    end

    @secret_word.split("").each_with_index do |char, i|
      if @match_locations.include?(i)
        print "#{char} "
      else
        print "_ "
      end
    end
    [@match_locations.count, @guessed_letters]
  end

  def get_dictionary
    File.readlines("dictionary.txt").map {|word| word.chomp}
  end

  def check_guess(guess)
    match_locations = []
    @secret_word.split("").each_with_index do |letter, i|
      if letter == guess
        match_locations << i
      end
    end
    match_locations
  end

  def guess
    filtered_length = filter_dict_on_length
    ["y", "_", "_", "_"]
    container_arr = []
    @current_word.each_with_index do |letter, i|
      if letter != "_"
        container_arr << [letter,i]
      end
    end
    more_words = []
    filtered_length.each_with_index do |word, i|
      check = true
      container_arr.each do |letter, correct_loc|
        check = false if word[correct_loc] != letter
      end
      more_words << word if check
    end

    new_name = remove_words_wo_guessed_letters(filtered_length)
    remove_words_misplaced_letters(new_name)
    get_popular_letter.sort.pop[0]
    # dictionary.select(letter = 4)
    # eleminate all words without guessed letters
    # eliminate all words with misplaced guessed letters
    # remaining_words.each |letter|  new_letter_arry << letter
    # new_letter_arry.sort[0]

  end

  def filter_dict_on_length
    @dictionary.select {|word| word.length == @secret_word_length}
  end

  def remove_words_wo_guessed_letters(dict)

  end

  def receive_secret_length
    puts "test"
    @secret_word_length
  end

end

class HumanPlayer
  attr_accessor :secret_word_length, :match_locations
  def initialize
    @secret_word_length
    @match_locations = []
    @display_word = []
  end

  def handle_guess_response(checked_guess, current_word)
    @display_word.each {|char| print "#{char} "}
    @display_word.join.scan(/[a-zA-Z]/).count
  end

  def receive_secret_length
    puts "What is the length of the word?"
    @secret_word_length = gets.chomp
    puts @secret_word_length
    @secret_word_length.to_i.times { @display_word << "_ "}
  end

  def guess
    print "What is your guess?  "
    gets.chomp
  end

  def check_guess(guess)
    match_locations = []
    puts "The computer guessed #{guess}.\nPlease enter comma separated locations of matches.
            Press enter if no matches."
    match_locations = gets.chomp.scan(/[0-9]+/).map(&:to_i)
    match_locations.each { |i| @display_word[i] = guess }
  end
end

computer_player = ComputerPlayer.new
human_player = HumanPlayer.new

# hangman = Game.new(human_player, computer_player)
hangman = Game.new(computer_player, human_player)
hangman.play
