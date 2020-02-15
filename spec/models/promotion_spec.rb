require './models/promotion'
require './helpers/constants'
RSpec.describe Promotion do
  context 'initialize' do
    it 'raise exception if type is on_item but item nil' do
      expect {Promotion.new(
          Constants::PromotionType::ON_ITEM,
          2,
          10,
          false,
          nil
      )}.to raise_error('item id required on on_item type')
    end
  end
end