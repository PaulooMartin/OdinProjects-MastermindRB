class Game
  KEYS = [1, 2, 3, 4, 5, 6, 7, 8].freeze

  def initialize(guesser, maker)
    @guesser = guesser
    @maker = maker
    @combination = ''
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

      combination.concat(digit.to_s).to_i
    end
    combination.to_i
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
    guess.to_i
  end
end
