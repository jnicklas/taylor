require "taylor/version"
require "taylor/generator"
require "taylor/column"
require "taylor/randomizer"

module Taylor
  extend self

  class << self
    attr_accessor :mass_assign
  end

  def generate(klass, attributes={})
    Taylor::Generator.new(klass).generate(attributes)
  end

  def generate!(klass, attributes={})
    generate(klass, attributes).tap(&:save!)
  end
end

Taylor.mass_assign = true
