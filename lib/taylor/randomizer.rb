module Taylor
  module Randomizer
    extend self

    CHARS = ["a".."z"].to_a

    def string(min, max)
      8.times.map { CHARS.sample }.join
    end
  end
end
