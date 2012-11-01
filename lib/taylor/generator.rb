require "active_model"

module Taylor
  VALIDATORS = {
    :presence => ActiveModel::Validations::PresenceValidator,
    :acceptance => ActiveModel::Validations::AcceptanceValidator,
    :format => ActiveModel::Validations::FormatValidator,
    :inclusion_of => ActiveModel::Validations::InclusionValidator,
    :length => ActiveModel::Validations::LengthValidator,
    :numericality => ActiveModel::Validations::NumericalityValidator,
  }

  class Column
    attr_reader :klass, :name, :column

    def initialize(klass, name, column)
      @klass = klass
      @name = name
      @column = column
    end

    def type
      if column
        column.type
      else
        :virtual
      end
    end

    def generate
      send(type) if respond_to?(type)
    end

    def virtual
      validation_names = validators.map { |v| VALIDATORS.invert[v.class] }
      if not (validation_names & [:inclusion_of, :format, :length]).empty?
        string
      elsif validation_names.include?(:numericality)
        integer
      elsif validation_names.include?(:acceptance)
        boolean
      elsif validation_names.include?(:presence)
        string
      end
    end

    def string
      if validator(:inclusion_of)
        options = validator(:inclusion_of).options[:in] || validator(:inclusion_of).options[:within]
        options.sample
      elsif validator(:format) and validator(:format).options[:with]
        Taylor::Randomizer.regexp(validator(:format).options[:with])
      elsif validator(:length)
        options = validator(:length).options
        if options[:is]
          Taylor::Randomizer.string(options[:is], options[:is])
        elsif options[:minimum]
          Taylor::Randomizer.string(options[:minimum], options[:maximum] || (options[:minimum]+8))
        elsif options[:maximum]
          Taylor::Randomizer.string(1, options[:maximum])
        end
      elsif validator(:presence)
        Taylor::Randomizer.string(4, 10)
      end
    end
    alias_method :text, :string

    def integer
      if validator(:numericality)
        options = validator(:numericality).options
        if options[:less_than]
          rand(options[:less_than])
        elsif options[:less_than_or_equal]
          rand(options[:less_than_or_equal] + 1)
        end
      elsif validator(:presence)
        rand(100000)
      end
    end

    def float
      if validator(:numericality)
        options = validator(:numericality).options
        if options[:less_than]
          rand * options[:less_than]
        elsif options[:less_than_or_equal]
          rand * options[:less_than_or_equal]
        end
      elsif validator(:presence)
        rand * 100000
      end
    end

    def decimal
      value = float
      BigDecimal.new(value.to_s) if value
    end

    def datetime
      Time.now if validator(:presence)
    end
    alias_method :timestamp, :datetime
    alias_method :time, :datetime

    def date
      Date.today if validator(:presence)
    end

    def boolean
      if validator(:acceptance) and not validator(:acceptance).options[:allow_nil]
        validator(:acceptance).options[:accept]
      end
    end

  private

    def validator(name)
      validators.find { |v| v.is_a?(VALIDATORS[name]) }
    end

    def validators
      klass.validators_on(name)
    end
  end

  class Generator
    attr_reader :klass

    def initialize(klass)
      @klass = klass
    end

    def generate
      pairs = columns.map do |column|
        value = column.generate
        [column.name, value] if value
      end
      klass.new(Hash[pairs])
    end

    def columns
      names = klass.validators.map do |validator|
        validator.attributes
      end.flatten.uniq
      names.map do |name|
        column = klass.columns_hash[name.to_s]
        Column.new(klass, name, column)
      end
    end
  end
end
