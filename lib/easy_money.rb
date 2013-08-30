require "bigdecimal"
require "currency_data"

class EasyMoney < BigDecimal
  def self.zero
    new 0
  end

  def initialize amount
    super(amount.to_s)
  end

  def to_s
    sprintf("%.2f", super)
  end

  def inspect
    "#<EasyMoney:#{super}>"
  end

  def + other
    EasyMoney.new(super)
  end

  def - other
    EasyMoney.new(super)
  end

  def / other
    EasyMoney.new(super)
  end

  def * other
    EasyMoney.new(super)
  end

  def positive?
    self > 0
  end

  def negative?
    self < 0
  end

  def cents(ratio = 100.0)
    self * ratio
  end

  # FIXME: needs polishing
  def with_currency iso_code
    currency = currency(iso_code) || raise(ArgumentError, "Unknown currency: #{iso_code}")

    left = to_i.to_s. # whole part
      reverse.scan(/.{1,3}/).map(&:reverse).reverse. # split every 3 digits right-to-left
      join(currency.thousands_separator)
    right = to_s.split(".").last

    formatted = [left, currency.decimal_mark, right].join

    formatted.public_send(
      currency.symbol_first ? :prepend : :append,
      currency.symbol
    )
  end

private

  def currency iso_code
    ::CurrencyData.find(iso_code)
  end
end
