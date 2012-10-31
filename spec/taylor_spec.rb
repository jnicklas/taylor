require "spec_helper"

describe Taylor do
  let(:time) { Time.now }

  context "with no validations" do
    it_is_valid_with { }
  end

  context "with validates_presence_of" do
    it_is_valid_with("string column")    { validates_presence_of :name }
    it_is_valid_with("text column")      { validates_presence_of :description }
    it_is_valid_with("integer column")   { validates_presence_of :amount }
    it_is_valid_with("float column")     { validates_presence_of :rating }
    it_is_valid_with("decimal column")   { validates_presence_of :price }
    it_is_valid_with("datetime column")  { validates_presence_of :published_at }
    it_is_valid_with("timestamp column") { validates_presence_of :invented_at }
    it_is_valid_with("date column")      { validates_presence_of :released_on }
    it_is_valid_with("time column")      { validates_presence_of :feed_after }
    it_is_valid_with("virtual column")   { validates_presence_of :virtual }
    it_is_valid_with("multiple columns") { validates_presence_of :name, :description, :price, :published_at }
  end

  context "with validates_acceptance_of" do
    it_is_valid_with("boolean column")   { validates_acceptance_of :terms_accepted, :accept => true, :allow_nil => false }
    it_is_valid_with("virtual column")   { validates_acceptance_of :virtual, :allow_nil => false }
    it_is_valid_with("with allow nil")   { validates_acceptance_of :virtual }
  end

  # validates_confirmation_of actually allows nil values, and only takes effect
  # when an empty or incorrect string is assigned, thus we don't need to really
  # do anything with it.
  context "with validates_confirmation_of" do
    it_is_valid_with("string column") do
      validates_presence_of :name
      validates_confirmation_of :name
    end
    it_is_valid_with("text column") do
      validates_presence_of :description
      validates_confirmation_of :description
    end
  end

  context "with validates_exclusion_of" do
    it_is_valid_with("string column") do
      validates_presence_of :name
      validates_confirmation_of :name
    end
    it_is_valid_with("text column") do
      validates_presence_of :description
      validates_confirmation_of :description
    end
  end

  context "with validates_format_of" do
    it_is_valid_with("string column") { validates_format_of :name, :with => /^[a-f0-9]{8}$/ }
    it_is_valid_with("text column")   { validates_format_of :description, :with => /^[a-f0-9]{8}$/ }
  end
end
