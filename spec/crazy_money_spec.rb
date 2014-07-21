# encoding: UTF-8

require "crazy_money"

describe CrazyMoney do
  let(:one_third) { BigDecimal.new(1) / BigDecimal.new(3) }

  describe ".zero" do
    specify { expect(CrazyMoney.zero).to eq(CrazyMoney.new(0)) }
  end

  describe "#to_s" do
    specify { expect(CrazyMoney.new(0).to_s).to eq("0.00") }
    specify { expect(CrazyMoney.new("13.37").to_s).to eq("13.37") }
    specify { expect(CrazyMoney.new("13.372").to_s).to eq("13.37") }
    specify { expect(CrazyMoney.new("13.377").to_s).to eq("13.38") }
    specify { expect(CrazyMoney.new(one_third).to_s).to eq("0.33") }
  end

  describe "#inspect" do
    specify { expect(CrazyMoney.new(0).inspect).to eq("#<CrazyMoney amount=0.00>") }
    specify { expect(CrazyMoney.new("-13.37").inspect).to eq("#<CrazyMoney amount=-13.37>") }
  end

  describe "#==" do
    specify { expect(CrazyMoney.new(0) == 0).to be true }
    specify { expect(CrazyMoney.new(one_third) == one_third).to be true }
    specify { expect(CrazyMoney.new("1.23456789") == 1.23456789).to be true }
    specify { expect(CrazyMoney.new(1.23456789) == 1.23456789).to be true }
  end

  describe "arithmetic operations" do
    shared_examples_for "it returns a CrazyMoney object" do
      specify { expect(@result).to be_a CrazyMoney }
    end

    before do
      @a = CrazyMoney.new(2)
      @b = CrazyMoney.new(3)
    end

    describe "#+" do
      before { @result = @a + @b }
      it_behaves_like "it returns a CrazyMoney object"
      specify { expect(@result).to eq(5) }
    end

    describe "#-" do
      before { @result = @a - @b }
      it_behaves_like "it returns a CrazyMoney object"
      specify { expect(@result).to eq(-1) }
    end

    describe "#*" do
      before { @result = @a * @b }
      it_behaves_like "it returns a CrazyMoney object"
      specify { expect(@result).to eq(6) }
    end

    describe "#/" do
      before { @result = @a / @b }
      it_behaves_like "it returns a CrazyMoney object"
      specify { expect(@result).to eq(BigDecimal.new(2) / BigDecimal.new(3)) }
    end
  end

  describe "#positive?" do
    specify { expect(CrazyMoney.new(-1)).to_not be_positive }
    specify { expect(CrazyMoney.new( 0)).to_not be_positive }
    specify { expect(CrazyMoney.new( 1)).to     be_positive }
  end

  describe "#negative?" do
    specify { expect(CrazyMoney.new(-1)).to     be_negative }
    specify { expect(CrazyMoney.new( 0)).to_not be_negative }
    specify { expect(CrazyMoney.new( 1)).to_not be_negative }
  end

  describe "#zero?" do
    specify { expect(CrazyMoney.new(0)).to be_zero }
    specify { expect(CrazyMoney.new(0.1)).to_not be_zero }
  end

  describe "#opposite" do
    specify { expect(CrazyMoney.new(0).opposite).to eq(0) }
    specify { expect(CrazyMoney.new(1.23).opposite).to eq(-1.23) }
    specify { expect(CrazyMoney.new(-20).opposite).to eq(20) }
    specify { expect(CrazyMoney.new(0).opposite).to be_a CrazyMoney }
  end

  describe "#cents" do
    specify { expect(CrazyMoney.new(1.23).cents).to eq(123) }
  end

  describe "comparison" do
    specify { expect(CrazyMoney.new(10) > 0).to be true }
    specify { expect(CrazyMoney.new(10) > CrazyMoney.new(0)).to be true }

    specify { expect([0, CrazyMoney.new(10)].max).to eq(10) }
    specify { expect([CrazyMoney.new(0), CrazyMoney.new(10)].max).to eq(10) }
  end

  describe "#with_currency" do
    specify { expect(CrazyMoney.new(one_third).with_currency("NZD")).to eq("$0.33") }

    specify { expect(CrazyMoney.new("13.37").with_currency("NZD")).to eq("$13.37") }
    specify { expect(CrazyMoney.new("-13.37").with_currency("NZD")).to eq("$-13.37") }
    specify { expect(CrazyMoney.new("0").with_currency("NZD")).to eq("$0.00") }

    specify { expect(CrazyMoney.new("123").with_currency("NZD")).to eq("$123.00") }
    specify { expect(CrazyMoney.new("-123").with_currency("NZD")).to eq("$-123.00") }

    specify { expect(CrazyMoney.new("13.37").with_currency("EUR")).to eq("€13,37") }
    specify { expect(CrazyMoney.new("-13.37").with_currency("EUR")).to eq("€-13,37") }
    specify { expect(CrazyMoney.new("0").with_currency("EUR")).to eq("€0,00") }

    specify { expect(CrazyMoney.new("-1234567.89").with_currency("USD")).to eq("$-1 234 567.89") }
    specify { expect(CrazyMoney.new("-1234567.89").with_currency("EUR")).to eq("€-1 234 567,89") }

    specify { expect(CrazyMoney.new("13.37").with_currency("SEK")).to eq("13,37 kr") }
    specify { expect(CrazyMoney.new("1337").with_currency("XPF")).to eq("1 337 CFP") }
  end
end

