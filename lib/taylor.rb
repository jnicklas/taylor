require "taylor/version"
require "taylor/generator"

module Taylor
  extend self

  def self.random(type, name)

  end

  def generate(klass)
    Taylor::Generator.new(klass).generate
  end
end
