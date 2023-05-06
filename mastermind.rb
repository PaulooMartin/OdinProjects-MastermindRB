class Game
  KEYS = [1, 2, 3, 4, 5, 6, 7, 8].freeze

  def initialize(guesser, maker)
    @guesser = guesser
    @maker = maker
  end
end

class Player
  attr_accessor :role

  def initialize(initial_role, computer: false)
    @role = initial_role
    @is_computer = computer
  end

  def make_combination_computer
    combination = ''
    until combination.length == 4
      digit = rand 1..8
      next if combination.include?(digit.to_s)

      combination.concat(digit.to_s).to_i
    end
    combination
  end
end