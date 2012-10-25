module Taylor
  class Generator
    attr_reader :klass

    def initialize(klass)
      @klass = klass
    end

    def generate
      record = klass.new
      if defined?(ActiveRecord::Base) and klass.ancestors.include?(ActiveRecord::Base)
        klass.columns.each do |column|
          writer_name = :"#{column.name}="
          if validation(:presence, column.name) and record.respond_to?(writer_name)
            record.send(writer_name, Taylor.random(column.type, column.name))
          end
        end
      end
      record
    end

    def validation(type, column)
      validator = case type
        when :presence then ActiveModel::Validations::PresenceValidator
      end
      klass.validators_on(column).find { |v| v.is_a? validator }
    end
  end
end
