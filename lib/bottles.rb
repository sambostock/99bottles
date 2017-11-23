class Bottles
  def initialize(lyricist: Lyricist.new, wall_class: Wall)
    @lyricist = lyricist
    @wall_class = wall_class
  end

  def song
    verses(99, 0)
  end

  def verses(starting_quantity, ending_quantity)
    starting_quantity.downto(ending_quantity)
      .map { |number_of_bottles| verse(number_of_bottles) }
      .reduce { |verses, verse| "#{verses}\n#{verse}" }
  end

  def verse(number_of_bottles)
    wall = wall_class.new(number_of_bottles)

    lyrics = lyricist.verse(wall)

    lyrics.publish
  end

  class Lyricist
    def verse(wall, lyrics: Lyrics.new)
      lyrics.write("#{describe_wall(wall)}, #{describe_contents(wall)}.")
      lyrics.write("#{describe_and_take_action(wall)}, #{describe_wall(wall)}.")

      lyrics
    end

    def describe_wall(wall)
      "#{describe_contents(wall)} on the wall"
    end

    def describe_contents(wall)
      wall.contents
    end

    def describe_and_take_action(wall, drinker: Drinker.new)
      action = drinker.examine(wall)
      
      action.perform

      action.description
    end
  end

  class Lyrics
    def initialize
      @lines = []
    end

    def write(line)
      lines << line.capitalize
    end

    def publish
      lines.join("\n") + "\n"
    end

    private

    attr_reader :lines
  end

  class Wall
    OutOfBeerError = Class.new(RangeError)
    NotEnoughBeerError = Class.new(RangeError)

    def initialize(bottles_of_beer)
      @bottles_of_beer = bottles_of_beer
    end

    def contents
      case bottles_of_beer
      when 0
        'no more bottles of beer'
      when 1
        '1 bottle of beer'
      else
        "#{bottles_of_beer} bottles of beer"
      end
    end

    def take(quantity=1)
      raise OutOfBeerError if bottles_of_beer == 0
      raise NotEnoughBeerError, 'not enough beer to take #{quantity}' if quantity > bottles_of_beer
      raise ArgumentError if quantity < 0

      self.bottles_of_beer -= quantity.ceil
    end

    def shelf(quantity=1)
      raise ArgumentError, "cannot shelf #{quantity} beers" if quantity < 0

      self.bottles_of_beer += quantity.floor
    end

    def empty?
      bottles_of_beer == 0
    end

    def one_left?
      bottles_of_beer == 1
    end

    protected

    attr_accessor :bottles_of_beer
  end

  class Drinker
    def examine(wall)
      if wall.empty?
        Replenish.new(wall: wall)
      else
        Drink.new(wall: wall)
      end
    end
  end

  class Action
    def initialize(wall:)
      @wall = wall
      @performed = false
    end

    def perform
      unless performed?
        act

        self.performed = true
      end
    end

    def act
      raise NotImplementedError
    end

    private

    attr_reader :wall
    attr_accessor :performed

    def performed?
      @performed
    end
  end

  class Drink < Action
    def act
      @took_last_beer = wall.one_left?

      wall.take(1)
    end

    def description
      noun = @took_last_beer ? 'it' : 'one'

      "take #{noun} down and pass it around"
    end
  end

  class Replenish < Action
    def act
      wall.shelf(99)
    end

    def description
      'go to the store and buy some more'
    end
  end

  private

  attr_reader :lyricist
  attr_reader :wall_class
end
