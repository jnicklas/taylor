require "spec_helper"

describe Taylor do
  let(:time) { Time.now }

  context "with no validations" do
    it_is_valid_with { }
    it "generates blank objects" do
      generate_class.new.attributes.values.compact.should == []
    end
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
    it_is_valid_with("string column")  { validates_format_of :name, :with => /^[a-f0-9]{8}$/ }
    it_is_valid_with("text column")    { validates_format_of :description, :with => /^[a-f0-9]{8}$/ }
    it_is_valid_with("virtual column") { validates_format_of :virtual, :with => /^[a-f0-9]{8}$/ }
  end

  context "with validates_inclusion_of" do
    context "with in option" do
      it_is_valid_with("string column")  { validates_inclusion_of :name, :in => %w[foo bar baz] }
      it_is_valid_with("text column")    { validates_inclusion_of :description, :in => %w[foo bar baz] }
      it_is_valid_with("virtual column") { validates_inclusion_of :virtual, :in => %w[foo bar baz] }
    end

    context "with within option" do
      it_is_valid_with("string column")  { validates_inclusion_of :name, :within => %w[foo bar baz] }
      it_is_valid_with("text column")    { validates_inclusion_of :description, :within => %w[foo bar baz] }
      it_is_valid_with("virtual column") { validates_inclusion_of :virtual, :within => %w[foo bar baz] }
    end

    context "with both" do
      it_is_valid_with("virtual column") { validates_inclusion_of :virtual, :within => %w[foo bar baz], :in => %w[blah] }
      it_is_valid_with("virtual column") { validates_inclusion_of :virtual, :in => %w[foo bar baz], :within => %w[blah] }
    end
  end

  context "with validates_length_of" do
    context "with minimum option" do
      it_is_valid_with("string column")  { validates_length_of :name, :minimum => 20 }
      it_is_valid_with("text column")    { validates_length_of :description, :minimum => 20 }
      it_is_valid_with("virtual column") { validates_length_of :virtual, :minimum => 20 }
    end

    context "with maximum option" do
      it_is_valid_with("string column")  { validates_length_of :name, :maximum => 4 }
      it_is_valid_with("text column")    { validates_length_of :description, :maximum => 4 }
      it_is_valid_with("virtual column") { validates_length_of :virtual, :maximum => 4 }
    end

    context "with minimum and maximum option" do
      it_is_valid_with("string column")  { validates_length_of :name, :minimum => 4, :maximum => 7 }
      it_is_valid_with("text column")    { validates_length_of :description, :minimum => 4, :maximum => 7 }
      it_is_valid_with("virtual column") { validates_length_of :virtual, :minimum => 4, :maximum => 7 }
    end

    context "with is option" do
      it_is_valid_with("string column")  { validates_length_of :name, :is => 4 }
      it_is_valid_with("text column")    { validates_length_of :description, :is => 4 }
      it_is_valid_with("virtual column") { validates_length_of :virtual, :is => 4 }
    end

    context "with within option" do
      it_is_valid_with("string column")  { validates_length_of :name, :within => 12..16 }
      it_is_valid_with("text column")    { validates_length_of :description, :within => 12..16 }
      it_is_valid_with("virtual column") { validates_length_of :virtual, :within => 12..16 }
    end
  end

  context "with validates_numericality_of" do
    context "with less than option" do
      it_is_valid_with("integer")  { validates_numericality_of :amount,  :less_than => 8 }
      it_is_valid_with("float")    { validates_numericality_of :rating,  :less_than => 8 }
      it_is_valid_with("decimal")  { validates_numericality_of :price,   :less_than => 8 }
      it_is_valid_with("virtual")  { validates_numericality_of :virtual, :less_than => 8 }
    end
  end
end
