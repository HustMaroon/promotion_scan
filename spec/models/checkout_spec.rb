require_relative '../../spec/spec_helper'
require_relative '../../models/checkout'
require_relative '../../spec/factories/item_factory'
require_relative '../../spec/factories/promotion_factory'
describe CheckOut do
  before(:all) do
    @item1 = build(:item, :item1)
    @item2 = build(:item, :item2)
    @item3 = build(:item, :item3)
    @promo1 = build(:promotion, :promo1)
    @promo2 = build(:promotion, :promo2)
  end
  context 'no promotion' do
    it 'calculate properly' do
      co = CheckOut.new([])
      co.scan(@item1)
      expect(co.total).to eq @item1.price
      co.scan(@item2)
      expect(co.total).to eq(@item1.price + @item2.price)
      co.scan(@item3)
      expect(co.total).to eq(@item1.price + @item2.price + @item3.price)
    end
  end

  context 'apply promo1' do
    before(:each) do
      @co = CheckOut.new([@promo1])
    end
    it 'no legal item' do
      @co.scan(@item2)
      expect(@co.total).to eq(@item2.price)
      @co.scan(@item3)
      expect(@co.total).to eq(@item2.price + @item3.price)
    end

    it '1 legal item but not exceed the threshold' do
      @co.scan(@item1)
      expect(@co.total).to eq @item1.price
    end

    it 'satisfy the promo' do
      expected_total = 2 * (9.25 - 0.75)
      @co.scan(@item1)
      @co.scan(@item1)
      expect(@co.total).to eq expected_total
    end

    it 'mix with other items' do
      expected_total = 45 + 19.95 + 2 * (9.25 - 0.75)
      @co.scan(@item2)
      @co.scan(@item1)
      @co.scan(@item3)
      @co.scan(@item1)
      expect(@co.total).to eq expected_total
    end
  end

  context 'apply promo 2' do
    before(:each) do
      @co = CheckOut.new([@promo2])
    end

    it 'not satisfied' do
      expected_total = 9.25 + 45
      @co.scan(@item1)
      @co.scan(@item2)
      expect(@co.total).to eq expected_total
    end

    it 'satisfied' do
      expected_total = (9.25 + 45 + 19.95) * 0.9
      @co.scan(@item1)
      @co.scan(@item2)
      @co.scan(@item3)
      expect(@co.total).to eq expected_total
    end
  end

  context 'apply promo1 and promo2' do
    before(:each) do
      @co = CheckOut.new([@promo1, @promo2])
    end

    it 'not satisfied' do
      expected_total = 9.25 + 45
      @co.scan(@item1)
      @co.scan(@item2)
      expect(@co.total).to eq expected_total
    end

    it 'promo1 satisfied' do
      expected_total = 2 * (9.25 - 0.75) + 19.95
      @co.scan(@item1)
      @co.scan(@item3)
      @co.scan(@item1)
      expect(@co.total).to eq expected_total
    end

    it 'promo2 satisfied' do
      expected_total = (9.25 + 19.95 + 45) * 0.9
      @co.scan(@item1)
      @co.scan(@item2)
      @co.scan(@item3)
      expect(@co.total).to eq expected_total
    end

    it 'both satisfied' do
      expected_total = ((9.25 - 0.75) * 2 + 45 + 19.95) * 0.9
      @co.scan(@item1)
      @co.scan(@item2)
      @co.scan(@item1)
      @co.scan(@item3)
      expect(@co.total).to eq expected_total
    end
  end
end