module Taylor
  class Generator
    attr_reader :klass

    def initialize(klass)
      @klass = klass
    end

    def generate(attributes)
      pairs = columns.map do |column|
        unless attributes.keys.include?(column.name)
          value = column.generate
          [column.name, value] if value
        end
      end
      attributes = Hash[pairs].merge(attributes)
      if Taylor.mass_assign
        klass.new(attributes)
      else
        klass.new.tap do |record|
          attributes.each do |key, value|
            record.public_send("#{key}=", value)
          end
        end
      end
    end

    def columns
      if klass.respond_to?(:validators)
        names = klass.validators.map do |validator|
          validator.attributes
        end.flatten.uniq
        names.map do |name|
          if klass.respond_to?(:columns_hash)
            column = klass.columns_hash[name.to_s]
          end
          Column.new(klass, name, column)
        end
      else
        []
      end
    end
  end
end
