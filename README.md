# CrazyMoney

This is a simplier version of the Money class which comes with the [Money Gem](https://github.com/RubyMoney/money).

It doesn't try to handle currency conversions but simply wraps an amount of money into a [BigDecimal](http://www.ruby-doc.org/stdlib-2.0/libdoc/bigdecimal/rdoc/BigDecimal.html) instance to avoid precision issues with floating point arithmetic operations.

Features:

- doesn't monkey-patch [Ruby core types](https://github.com/RubyMoney/money/blob/master/lib/money/core_extensions.rb)
- less than 100 lines of code
- currency formatting support, e.g. `CrazyMoney.new("1234.56").with_currency("NZD") #=> "$1,234.56"`
- easy to integrate with Rails (see [Rails](#rails))

## Usage

```ruby
amount = CrazyMoney.new("13.37")
amount > 1 #=> true
amount == 13 #=> false
amount == 13.37 #=> true
amount == CrazyMoney.new(13.37) #=> true
amount.cents.to_i #=> 1337
amount.with_currency("NZD") #=> "$13.37"
```

### Rails

At the moment, there is no built-in support for Rails but you can use this initializer as a drop-in
replacement for the `monetize` helper that is provided by the Money Gem.

```ruby
# config/initializers/crazy_money.rb

class ActiveRecord::Base
  class << self
    def monetize attribute_cents
      attribute = attribute_cents.to_s.sub(/_cents$/, "")

      define_method attribute do
        CrazyMoney.new(send(attribute_cents)) / 100
      end

      define_method "#{attribute}=" do |value|
        send("#{attribute_cents}=", CrazyMoney.new(value).cents)
      end
    end
  end
end
```

