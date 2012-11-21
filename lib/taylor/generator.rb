module Taylor
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
