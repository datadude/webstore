require 'rails_helper'

RSpec.describe Item, :type => :model do
  describe 'add an item' do
    before :each do
      @attribs = {
      display_name: 'this is the display name',
      promo_text: 'this is the short promo text',
      promo_text_long: 'this is the long promo text',
      thumnail_path: '/thumbnails/items/1234567',
      graphic_path: '/images/items/1234567',
      piggybak_sellable: Piggybak::Sellable.new({
        sku: '12345678abcd',
        description: 'first item',
        price: 1.00,
        quantity: 10,
        item_id: 123456,
        item_type: 0,
        active: true,
        unlimited_inventory: true
        })
      }
    end
    it 'should add an item' do
      item = Item.new(@attribs)
      item.save
      expect(item.errors.empty?).to be_truthy
    end

    it 'should act as a sellable and return sellable attribs as its own' do
      item = Item.new(@attribs)
      expect(item.sku).to eq('12345678abcd')
    end

    it 'should set sellable attribs also' do
      item = Item.new(@attribs)
      item.sku = 'abcd123'
      item.save
      item1 = Item.find(item.id)
      expect(item1.sku).to eq('abcd123')
    end
  end
end
