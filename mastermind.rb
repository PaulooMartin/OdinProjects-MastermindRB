class Game
  KEYS = [1, 2, 3, 4, 5, 6, 7, 8].freeze

  def initialize(guesser, maker, total_guesses)
    @guesser = guesser
    @maker = maker
    @guesses_left = total_guesses
    @combination = ''
    @current_guess = ''
  end

  # ! Temp for now
  # ! For computer vs human for now
  def start
    @combination = @maker.make_combination
    is_win = false
    correct = 0
    incorrect = 0
    until is_win
      break if @guesses_left.zero?

      @current_guess = @guesser.guess_combination(correct, incorrect)
      is_win, correct, incorrect = give_feedback_on_guess
    end
    end_message(is_win)
  end

  private

  def give_feedback_on_guess
    @guesses_left -= 1
    return true if @combination == @current_guess

    correct = check_correct_placements
    incorrect = check_incorrect_placements
    puts "Number of correct placement: #{correct}"
    puts "Number of incorrect placement: #{incorrect} \n \n"
    [false, correct, incorrect]
  end

  def check_correct_placements
    total = 0
    guess_copy = @current_guess
    @combination.length.times do |index|
      if @combination[index] == @current_guess[index]
        total += 1
        guess_copy = guess_copy.delete(@current_guess[index])
      end
    end
    @current_guess = guess_copy
    total
  end

  def check_incorrect_placements
    total = 0
    guess_copy = @current_guess
    @current_guess.length.times do |index|
      if @combination.include?(@current_guess[index])
        total += 1
        guess_copy = guess_copy.delete(@current_guess[index])
      end
    end
    @current_guess = guess_copy
    total
  end

  def end_message(result)
    puts "You did not win. The combination was #{@combination}" unless result
    puts 'You guessed the combination! Nice.' if result
  end

  def start_message
    puts 'Welcome to Mastermind!'
    sleep 1
    puts 'In this game, you try to guess what the code-combination is'
    sleep 1
    puts "The code composes of 4 digits, from 1 to 8. You have a total of #{@guesses_left} guesses"
    puts "Goodluck! \n \n"
  end

  def switch_roles
    temp = @guesser
    @guesser = @maker
    @maker = temp

    @maker.role = 'maker'
    @guesser.role = 'guesser'
  end
end

class Player
  attr_writer :role, :is_computer

  def initialize(initial_role, computer)
    @role = initial_role
    @is_computer = computer
    return unless @is_computer

    @current_key = 0
    @right_keys_and_positions = []
    @locked_keys = []
  end

  def make_combination
    return make_combination_computer if @is_computer

    combination_human # ! Don't forget to refactor
  end

  def guess_combination(correct, incorrect)
    return guess_combination_computer(correct, incorrect) if @is_computer

    combination_human
  end

  private

  def make_combination_computer
    combination = ''
    until combination.length == 4
      digit = rand 1..8
      next if combination.include?(digit.to_s)

      combination.concat(digit.to_s)
    end
    combination
  end

  def guess_combination_computer(correct, incorrect)
    combination = ''
    4.times { combination.concat(@current_key.to_s) } if @right_digits.empty?
    # call something to set combination unless rightdigits.empty?
    # # Shifting right digit until right spot + fill in blanks with current_key
    @current_key += 1 if @current_key < 8
    p combination
  end

  def evaluate_feedback(correct, incorrect)
    total = correct + incorrect
    return if total.zero?

    # call something if correct = 1 and rightdigits.empty? FIRST KEY FOUND
    # call something if total = 4 and rightdigits.length < 3 NEXT KEY FOUND AND THE ONLY AVAIL POSITION LOGIC
    # call something if total > rightdigits.length NEXT KEY FOUND
    # # position of new key is everything else except the current positions of previous keys
  end

  def combination_human
    combination = ''
    valid = false
    text = @role == 'guesser' ? 'Guess the' : 'Enter your'
    until valid
      puts "#{text} combination: "
      combination = gets.chomp
      valid = true if combination.match?(/^\d\d\d\d$/)
      valid = false if combination.include?('0') || combination.include?('9')
    end
    combination
  end
end

# Just a simulation
combuter = Player.new('guesser', true)
human = Player.new('maker', true)
mastermind = Game.new(human, combuter, 12)

mastermind.start
