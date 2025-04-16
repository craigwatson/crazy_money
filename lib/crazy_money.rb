require "bigdecimal"
require "i18n"
require "currency_data"

class CrazyMoney
  include Comparable

  module Configuration
    class << self
      attr_accessor :current_currency
    end
  end

  def self.zero
    new 0
  end

  def initialize(amount)
    @amount = BigDecimal(amount.to_s)
  end

  def to_s(decimal_places: 2)
    if current_currency = Configuration.current_currency
      decimal_places = currency(current_currency).decimal_places
    end

    sprintf("%.#{decimal_places}f", @amount)
  end

  def to_i
    @amount.to_i
  end

  def to_k
    if @amount.abs < 1E3
      amount, suffix = @amount, ""
    else
      amount, suffix = (@amount / 1E3), "k"
    end

    "#{amount.round.to_i}#{suffix}".freeze
  end

  def inspect
    "#<CrazyMoney amount=#{self}>"
  end

  def ==(other)
    @amount == BigDecimal(other.to_s)
  end
  alias_method :eql?, :==

  def <=>(other)
    @amount <=> BigDecimal(other.to_s)
  end

  def positive?
    @amount > 0
  end

  def negative?
    @amount < 0
  end

  def zero?
    @amount.zero?
  end

  def opposite
    self.class.new(self * -1)
  end

  def round(*args)
    self.class.new(@amount.round(*args))
  end

  def cents(ratio = 100)
    @amount * BigDecimal(ratio.to_s)
  end

  def +(other); self.class.new(@amount + BigDecimal(other.to_s)); end

  def -(other); self.class.new(@amount - BigDecimal(other.to_s)); end

  def /(other); self.class.new(@amount / BigDecimal(other.to_s)); end

  def *(other); self.class.new(@amount * BigDecimal(other.to_s)); end

  # FIXME: needs polishing
  def with_currency(iso_code)
    currency = currency(iso_code) || raise(ArgumentError, "Unknown currency: #{iso_code.inspect}")

    left, right = to_s(decimal_places: currency.decimal_places).split(".")
    decimal_mark = right.nil? ? "" : currency.decimal_mark
    sign = left.slice!("-")

    left = left.reverse.scan(/.{1,3}/).map(&:reverse).reverse # split every 3 digits right-to-left
           .join(thousands_separator)

    formatted = [sign, left, decimal_mark, right].join

    if currency.symbol_first
      [currency.prefered_symbol, formatted]
    else
      [formatted, " ", currency.prefered_symbol]
    end.join
  end

private

  def thousands_separator
    default = " ".freeze
    I18n.t("number.currency.format.thousands_separator", default: default)
  rescue I18n::InvalidLocale
    default
  end

  def currency(iso_code)
    ::CurrencyData.find(iso_code)
  end
end
