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
    until is_win
      break if @guesses_left.zero?

      @current_guess = @guesser.make_combination
      is_win = give_feedback_on_guess
      @guesses_left -= 1
    end
  end

  private

  def give_feedback_on_guess
    return true if @combination == @current_guess

    correct = check_correct_placements
    incorrect = check_incorrect_placements
    puts "Number of correct placement: #{correct}"
    puts "Number of incorrect placement: #{incorrect}"
    false
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
end

class Player
  attr_accessor :role

  def initialize(initial_role, computer)
    @role = initial_role
    @is_computer = computer
  end

  def make_combination
    return make_combination_computer if @is_computer

    combination_human # ! Don't forget to refactor
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

  # TODO: Going to have to refactor because I just realize that guessing and making
  # TODO: a combination as a human player is the same.
  def combination_human
    guess = ''
    valid = false
    until valid
      puts 'Guess the combination: '
      guess = gets.chomp
      valid = true if guess.match?(/^\d\d\d\d$/)
      valid = false if guess.include?('0') || guess.include?('9')
    end
    guess
  end
end
