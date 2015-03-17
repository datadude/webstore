require 'rails_helper'
describe "Shopping Cart" do
  fixtures :items, :piggybak_sellables
  def add_tables(number)
    visit '/'
    page.assert_selector('form#1234567892')
    within('#1234567892') do
      fill_in 'quantity', with: number
      click_button 'Add to Cart'
    end
  end

  feature "add" do
    before :each do
      add_tables(1)
    end

    scenario "one item." do
      page.assert_selector 'input#quantity_3'
      expect(find_field('quantity_3').value).to eq '1'
    end

    scenario "multiple items." do
      click_link 'Continue Shopping'
      within('#1234567898') do
        fill_in 'quantity', with: 2
        click_button 'Add to Cart'
      end
      expect(find_field('quantity_3').value).to eq '1'
      expect(find_field('quantity_9').value).to eq '2'
      expect(find('td#subtotal_total').text).to eq '$7.00'
      expect(find('td#subtotal_total')['data-total']).to eq '7.0'
    end
  end

  feature "remove" do
    before :each do
      add_tables(2)
    end

    scenario "item." do
      page.assert_selector('a#remove-1234567892')
      find('a#remove-1234567892').click
      expect(page).to have_content 'Your cart is empty.'
      expect(page).to have_link "Continue Shopping"
    end

  end
  feature "update" do
    before :each do
      add_tables(2)
    end

    scenario "item." do
      page.assert_selector('input#quantity_3')
      within 'form#cart_form' do
        fill_in "quantity_3", with: 1
        click_button "Update Cart"
      end
      expect(find_field('quantity_3').value).to eq '1'
      expect(find('td#subtotal_total').text).to eq '$1.00'
      expect(find('td#subtotal_total')['data-total']).to eq '1.0'
    end

    scenario "amounts to zero." do
      within 'form#cart_form' do
        fill_in "quantity_3", with: 0
        click_button "Update Cart"
      end
      expect(page).to have_content 'Your cart is empty.'
      expect(page).to have_link "Continue Shopping"
    end

  end
  describe "Cart Window" do
    before :each do
      add_tables(2)
      click_link 'Continue Shopping'
    end
    it "should display div for cart window" do
      page.assert_selector('div#cart_window')
    end
    it "should display number of items" do
        expect(find('div#cart_window')).to have_content 'Items: 2'
    end

    it "should display total amount" do
      expect(find('div#cart_window')).to have_content 'Amount: $2.00'
    end

    it 'should display "checkout" button' do
      expect(find('div#cart_window a.button').text).to eq 'Check Out'
      expect(find('div#cart_window a.button')[:href]).to eq piggybak.orders_url
    end

  end
end

