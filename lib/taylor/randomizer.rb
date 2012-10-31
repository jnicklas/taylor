module Taylor
  module Randomizer
    extend self

    CHARS = ("a".."z").to_a

    def string(min, max)
      number = rand(max - min + 1) + min
      number.times.map { CHARS.sample }.join
    end

    def regexp(exp)
      require "expgen"
      Expgen.gen(exp)
    end
  end
end
