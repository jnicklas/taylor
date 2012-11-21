require "taylor/version"
require "taylor/generator"
require "taylor/column"
require "taylor/randomizer"

module Taylor
  extend self

  def self.random(type, name)

  end

  def generate(klass)
    Taylor::Generator.new(klass).generate
  end
end
