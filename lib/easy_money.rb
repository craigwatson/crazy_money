require "bigdecimal"
require "currency_data"

class EasyMoney
  include Comparable

  def self.zero
    new 0
  end

  def initialize amount
    @amount = BigDecimal.new(amount.to_s)
  end

  def to_s
    sprintf("%.2f", @amount)
  end

  def == other
    @amount == BigDecimal.new(other.to_s)
  end
  alias_method :eql?, :==

  def <=> other
    @amount <=> BigDecimal.new(other.to_s)
  end

  def positive?
    @amount > 0
  end

  def negative?
    @amount < 0
  end

  def cents(ratio = 100.0)
    @amount * ratio
  end

  def + other; operation other; end
  def - other; operation other; end
  def / other; operation other; end
  def * other; operation other; end

  # FIXME: needs polishing
  def with_currency iso_code
    currency = currency(iso_code) || raise(ArgumentError, "Unknown currency: #{iso_code}")

    left, right = to_s.split(".")

    left = left.reverse.scan(/.{1,3}/).map(&:reverse).reverse. # split every 3 digits right-to-left
      join(currency.thousands_separator)

    formatted = [left, currency.decimal_mark, right].join

    formatted.public_send(
      currency.symbol_first ? :prepend : :append,
      currency.symbol
    )
  end

private

  def operation other
    operation = caller[0][/`.*'/][1..-2]

    EasyMoney.new(
      @amount.public_send(
        operation, BigDecimal.new(other.to_s)
      )
    )
  end

  def currency iso_code
    ::CurrencyData.find(iso_code)
  end
end
