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
end
