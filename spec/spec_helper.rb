require "taylor"
require "active_record"
require "pry"

ActiveRecord::Base.establish_connection :adapter => "sqlite3", :database => ":memory:"

ActiveRecord::Base.connection.create_table :products do |t|
  t.string :name
  t.text :description
  t.integer :amount
  t.float :rating
  t.decimal :price, :precision => 6, :scale => 2
  t.datetime :published_at
  t.timestamp :invented_at
  t.date :released_on
  t.time :feed_after
  t.boolean :terms_accepted
end

module TaylorSpecHelper
  module IsValidWith
    def it_is_valid_with(description="", *args, &block)
      it "generates valid data with #{description}", *args do
        klass = generate_class(&block)
        20.times do
          Taylor.generate(klass).should be_valid
        end
        record = Taylor.generate(klass)
        record.save!
        klass.where(:id => record.id).should exist
      end
    end
  end

  module Generate
    extend RSpec::Matchers::DSL

    def generate_class(&block)
      Class.new(ActiveRecord::Base) do
        attr_accessor :virtual
        self.table_name = "products"
        instance_eval(&block) if block
        Object.const_set("TaylorSpecProduct", self)
      end
    end

    matcher :be_valid do
      match do |record|
        record.valid?
      end
      failure_message_for_should do |record|
        "#{record.inspect} should be valid, but had errors: #{record.errors.full_messages.join(", ")}"
      end
    end
  end
end

RSpec.configure do |config|
  config.extend TaylorSpecHelper::IsValidWith
  config.include TaylorSpecHelper::Generate
  config.after { Object.send(:remove_const, "TaylorSpecProduct") if defined?(TaylorSpecProduct) }
end
