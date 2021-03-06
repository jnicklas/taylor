module Taylor
  class Column
    attr_reader :klass, :name, :column

    def initialize(klass, name, column)
      @klass = klass
      @name = name
      @column = column
    end

    def type
      if association_reflection
        :association
      elsif column
        column.type
      else
        :virtual
      end
    end

    def generate
      send(type) if respond_to?(type)
    end

    def association
      Taylor.generate(association_reflection.klass)
    end

    def virtual
      validation_names = validators.map { |v| validator_types.invert[v.class] }
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
        elsif options[:greater_than]
          rand(100000) + options[:greater_than]
        elsif options[:greater_than_or_equal]
          rand(100000) + options[:greater_than_or_equal] + 1
        else
          rand(100000)
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
        elsif options[:greater_than]
          (rand * 100000) + options[:greater_than]
        elsif options[:greater_than_or_equal]
          (rand * 100000) + options[:greater_than_or_equal]
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

    def validator_types
      {
        :presence =>     ActiveModel::Validations::PresenceValidator,
        :acceptance =>   ActiveModel::Validations::AcceptanceValidator,
        :format =>       ActiveModel::Validations::FormatValidator,
        :inclusion_of => ActiveModel::Validations::InclusionValidator,
        :length =>       ActiveModel::Validations::LengthValidator,
        :numericality => ActiveModel::Validations::NumericalityValidator,
      }
    end

    def association_reflection
      if klass.respond_to?(:reflect_on_association)
        klass.reflect_on_association(name)
      end
    end

    def validator(name)
      validators.find { |v| v.is_a?(validator_types[name]) }
    end

    def validators
      klass.validators_on(name)
    end
  end
end
