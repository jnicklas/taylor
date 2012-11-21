require "taylor/version"
require "taylor/generator"
require "taylor/column"
require "taylor/randomizer"

module Taylor
  extend self

  def generate(klass)
    Taylor::Generator.new(klass).generate
  end
end
