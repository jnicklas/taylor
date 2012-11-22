# Taylor

Taylor is a gem which generates random, valid ActiveRecord models. It's similar
to FactoryGirl or Machinist, except that it can infer how to generate most
classes which use ActiveModel validations automatically.

# Installation

Add this to your Gemfile:

``` ruby
group :test do
  gem "taylor"
end
```

# Introduction

Suppose you have model called Product which looks like this:

``` ruby
class Product < ActiveRecord::Base
  validates_presence_of :name, :price, :category
  validates_inclusion_of :category, :in => %w[suv roadster van]
  validates_length_of :name, :minimum => 4
  validates_numericality_of :price, :greater_than_or_equal_to => 0
end
```

Usually you would now have to specify how to generate such a model, but with
Taylor, you can just start generating them without doing any additional work:

``` ruby
product = Taylor.generate(Product)
product.name # => "hasd"
product.price # => 34
product.category # => "suv"
```

Taylor has analyzed the validations on the class and generated a blueprint
automatically for you.

Just like with other similar libraries, you can override specific attributes:

``` ruby
product = Taylor.generate(Product, :name => "Golf")
product.name # => "Golf"
product.price # => 12
product.category # => "van"
```

# Persistence

If you want to persist the generated model, just call `generate!` instead:

``` ruby
product = Taylor.generate!(Product, :name => "Golf")
product.name # => "Golf"
product.price # => 12
product.category # => "van"
product.persisted? # => true
```

This will call `save!` on the record after it is generated.

# A note on mass assignment

Protecting from mass assignment in the model is a fundamentally flawed idea.
Taylor will initialize models by passing in a hash. If you have set up mass
assignment protection at the model layer, this will most likely fail. I
encourage you to protect against mass assignment where the attributes actually
come in, in the controller, or delegate this responsibility to another Object.

If you truly must, you can tell Taylor not to use mass assignment, but to set
attributes one by one, which is more like FactoryGirl and Machinist behave:

``` ruby
Taylor.mass_assignment = false
```

# Manual specification

Sometimes Taylor doesn't get it quite right. In this case you can manipulate
the attributes that will be set by calling the `specify` method:

``` ruby
Taylor.specify(Product) do |attributes|
  attributes[:name] = %w[Polo Golf Scirocco].sample
end
```

# Hooks

Sometimes you want to do something after the model is generated. You can use the
following hook:

``` ruby
Taylor.after_generate(Product) do |product|
  product.do_something!
end
```

This hook is called after the record has been instantiated, and the instance of
the record is passed in as an argument. If you use `generate!`, this hook is
called *before* the record is saved. If you instead want to do something
*after* the record is saved, use the following:

``` ruby
Taylor.after_save(Product) do |product|
  product.versions << Taylor.generate!(ProductVersion)
end
```

Note that if you generate a model with `generate`, without the bang, the above
hook is never called.

# RSpec and other test frameworks.

Including the `Taylor` module into the context of your tests will give you
access to `generate` and `generate!` directly. For example:

``` ruby
RSpec.configure do |config|
  config.include Taylor, :type => :model
end

describe Product do
  it "requires a name" do
    generate(Product, :name => nil).should have(1).error_on(:name)
  end
end
```

Optionally you can also extend the class under test or its superclass with
the Taylor::Model module, for a convenient shortcut:

``` ruby
ActiveRecord::Base.extend Taylor::Model

describe Product do
  it "requires a name" do
    Product.generate(:name => nil).should have(1).error_on(:name)
  end
end
```

You are free to choose which syntax you prefer. The latter is maybe more
readable, whereas the former can help you generate a wider variety of models
without additional setup.

# License

MIT, see separate LICENSE.txt file.
