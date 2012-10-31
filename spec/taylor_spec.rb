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
end
