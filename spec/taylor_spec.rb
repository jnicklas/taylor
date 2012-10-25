require "spec_helper"

describe Taylor do
  let(:time) { Time.now }

  def generate_class(&block)
    Class.new(ActiveRecord::Base) do
      self.table_name = "products"
      instance_eval(&block) if block
      Object.const_set("Product", self)
    end
  end

  before(:all) do
    ActiveRecord::Base.connection.create_table :products do |t|
      t.string :name
      t.integer :price
      t.datetime :published_at
    end
  end

  after { Object.send(:remove_const, "Product") if defined?(Product) }

  context "with no validations" do
    it "generates an empty object" do
      klass = generate_class
      record = Taylor.generate(klass)
      record.class.should == klass
      record.attributes.values.compact.should be_empty
    end
  end

  context "with presence validations" do
    it "fills in any required fields with a sensible value" do
      Taylor.stub(:random).with(:string, "name").and_return("John")
      Taylor.stub(:random).with(:integer, "price").and_return(3)
      Taylor.stub(:random).with(:datetime, "published_at").and_return(time)

      klass = generate_class { validates_presence_of *(column_names - ["id"]) }
      record = Taylor.generate(klass)
      record.class.should == klass
      record.name.should == "John"
      record.price.should == 3
      record.published_at.should == time
    end
  end
end
