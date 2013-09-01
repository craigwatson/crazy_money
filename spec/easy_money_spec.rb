# encoding: UTF-8

require "easy_money"

describe EasyMoney do
  let(:one_third) { BigDecimal.new(1) / BigDecimal.new(3) }

  describe ".zero" do
    specify { expect(EasyMoney.zero).to eq(EasyMoney.new(0)) }
  end

  describe "#to_s" do
    specify { expect(EasyMoney.new(0).to_s).to eq("0.00") }
    specify { expect(EasyMoney.new("13.37").to_s).to eq("13.37") }
    specify { expect(EasyMoney.new("13.372").to_s).to eq("13.37") }
    specify { expect(EasyMoney.new("13.377").to_s).to eq("13.38") }
    specify { expect(EasyMoney.new(one_third).to_s).to eq("0.33") }
  end

  describe "#==" do
    specify { expect(EasyMoney.new(0) == 0).to be_true }
    specify { expect(EasyMoney.new(one_third) == one_third).to be_true }
    specify { expect(EasyMoney.new("1.23456789") == 1.23456789).to be_true }
    specify { expect(EasyMoney.new(1.23456789) == 1.23456789).to be_true }
  end

  describe "arithmetic operations" do
    shared_examples_for "it returns a EasyMoney object" do
      specify { expect(@result).to be_a EasyMoney }
    end

    before do
      @a = EasyMoney.new(2)
      @b = EasyMoney.new(3)
    end

    describe "#+" do
      before { @result = @a + @b }
      it_behaves_like "it returns a EasyMoney object"
      specify { expect(@result).to eq(5) }
    end

    describe "#-" do
      before { @result = @a - @b }
      it_behaves_like "it returns a EasyMoney object"
      specify { expect(@result).to eq(-1) }
    end

    describe "#*" do
      before { @result = @a * @b }
      it_behaves_like "it returns a EasyMoney object"
      specify { expect(@result).to eq(6) }
    end

    describe "#/" do
      before { @result = @a / @b }
      it_behaves_like "it returns a EasyMoney object"
      specify { expect(@result).to eq(BigDecimal.new(2) / BigDecimal.new(3)) }
    end
  end

  describe "#with_currency" do
    specify { expect(EasyMoney.new(one_third).with_currency("NZD")).to eq("$0.33") }

    specify { expect(EasyMoney.new("13.37").with_currency("NZD")).to eq("$13.37") }
    specify { expect(EasyMoney.new("-13.37").with_currency("NZD")).to eq("$-13.37") }
    specify { expect(EasyMoney.new("0").with_currency("NZD")).to eq("$0.00") }

    specify { expect(EasyMoney.new("13.37").with_currency("EUR")).to eq("€13,37") }
    specify { expect(EasyMoney.new("-13.37").with_currency("EUR")).to eq("€-13,37") }
    specify { expect(EasyMoney.new("0").with_currency("EUR")).to eq("€0,00") }

    specify { expect(EasyMoney.new("-1234567.89").with_currency("USD")).to eq("$-1,234,567.89") }
    specify { expect(EasyMoney.new("-1234567.89").with_currency("EUR")).to eq("€-1.234.567,89") }
  end
end

