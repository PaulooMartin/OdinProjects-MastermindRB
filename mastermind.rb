class Game
  attr_reader :current_guess

  def initialize(guesser, maker, total_guesses)
    @guesser = guesser
    @maker = maker
    @guesses_left = total_guesses
    @combination = ''
    @combination_copy = ''
    @current_guess = ''
  end

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
    @combination_copy = String.new(@combination)
    @combination.length.times do |index|
      next unless @combination[index] == @current_guess[index]

      total += 1
      @current_guess[index] = 'a'
      @combination_copy[index] = 'z'
    end
    total
  end

  def check_incorrect_placements
    total = 0
    @current_guess.length.times do |guess_index|
      @combination_copy.length.times do |combination_index|
        next unless @current_guess[guess_index] == @combination_copy[combination_index]

        total += 1
        @current_guess[guess_index] = 'b'
        @combination_copy[combination_index] = 'y'
      end
    end
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
    return unless computer

    @possible_combinations = all_possible_combination
    @first_guess = 0
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
      digit = rand 1..6
      combination.concat(digit.to_s)
    end
    combination
  end

  def guess_combination_computer(correct, incorrect)
    if @first_guess.zero?
      @first_guess += 1
      return '1122'
    end

    last_guess_correct = correct
    last_guess_incorrect = incorrect
    remove_improbable_guesses(last_guess_correct, last_guess_incorrect)
    @first_guess += 1
    String.new(@possible_combinations[0])
  end

  def remove_improbable_guesses(last_correct, last_incorrect)
    fake_combination = @first_guess == 1 ? '1122' : @possible_combinations[0]
    @possible_combinations = @possible_combinations.keep_if do |code|
      next if code == fake_combination

      correct, combination_mod, guess_mod = feedback_correct_placement(String.new(fake_combination), String.new(code))
      incorrect = feedback_incorrect_placement(combination_mod, guess_mod)
      correct == last_correct && incorrect == last_incorrect
    end
  end

  def feedback_correct_placement(combination, guess)
    total = 0
    combination.length.times do |index|
      next unless combination[index] == guess[index]

      total += 1
      guess[index] = 'a'
      combination[index] = 'z'
    end
    [total, combination, guess]
  end

  def feedback_incorrect_placement(combination, guess)
    total = 0
    guess.length.times do |guess_index|
      combination.length.times do |combination_index|
        next unless guess[guess_index] == combination[combination_index]

        total += 1
        guess[guess_index] = 'b'
        combination[combination_index] = 'y'
      end
    end
    total
  end

  def all_possible_combination
    combination = []
    counter = 1111
    while counter < 6667
      combination.push(counter.to_s)
      counter += 1
    end
    combination.keep_if do |element|
      element.match?(/\A[1-6][1-6][1-6][1-6]\z/)
    end
  end

  def combination_human
    combination = ''
    valid = false
    text = @role == 'guesser' ? 'Guess the' : 'Enter a valid'
    until valid
      puts "#{text} combination: "
      combination = gets.chomp
      valid = combination.match?(/\A[1-6][1-6][1-6][1-6]\z/)
    end
    combination
  end
end

# Just a simulation
combuter = Player.new('guesser', true)
human = Player.new('maker', false)
mastermind = Game.new(combuter, human, 8)

mastermind.start
