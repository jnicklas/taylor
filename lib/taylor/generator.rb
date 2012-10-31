require "active_model"

module Taylor
  VALIDATORS = {
    :presence => ActiveModel::Validations::PresenceValidator,
    :acceptance => ActiveModel::Validations::AcceptanceValidator,
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
      if validator(:acceptance) and not validator(:acceptance).options[:allow_nil]
        validator(:acceptance).options[:accept]
      else
        string
      end
    end

    def string
      if validator(:presence)
        Taylor::Randomizer.string(4, 10)
      end
    end
    alias_method :text, :string

    def integer
      rand(10000)
    end

    def float
      rand
    end

    def decimal
      BigDecimal.new(rand(10000)) / 100
    end

    def datetime
      Time.now
    end
    alias_method :timestamp, :datetime
    alias_method :time, :datetime

    def date
      Date.today
    end

    def boolean
      if validator(:acceptance) and not validator(:acceptance).options[:allow_nil]
        validator(:acceptance).options[:accept]
      else
        [true, false].sample
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
      record = klass.new
      columns.each do |column|
        writer_name = :"#{column.name}="
        if record.respond_to?(writer_name)
          record.send(writer_name, column.generate)
        end
      end
      record
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
