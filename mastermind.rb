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
    start_message
    @combination = @maker.make_combination
    is_win = false
    until is_win
      break if @guesses_left.zero?

      @current_guess = @guesser.guess_combination
      is_win = give_feedback_on_guess
      @guesses_left -= 1
    end
    end_message(is_win)
  end

  private

  def give_feedback_on_guess
    return true if @combination == @current_guess

    correct = check_correct_placements
    incorrect = check_incorrect_placements
    puts "Number of correct placement: #{correct}"
    puts "Number of incorrect placement: #{incorrect} \n \n"
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
  end

  def make_combination
    return make_combination_computer if @is_computer

    combination_human # ! Don't forget to refactor
  end

  def guess_combination
    return guess_combination_computer if @is_computer

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

  def guess_combination_computer; end

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
combuter = Player.new('maker', true)
human = Player.new('guesser', false)
mastermind = Game.new(human, combuter, 12)

mastermind.start
