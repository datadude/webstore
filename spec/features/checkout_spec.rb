require 'rails_helper'
describe "Checkout Page" do
  fixtures :piggybak_countries, :piggybak_states, :piggybak_payment_methods, :piggybak_payment_method_values,
           :piggybak_sellables, :piggybak_shipping_methods, :piggybak_shipping_method_values, :piggybak_tax_methods,
           :piggybak_tax_method_values, :items, :users
  def add_tables(number)
    page.assert_selector('form#1234567892')
    within('#1234567892') do
      fill_in 'quantity', with: number
      click_button 'Add to Cart'
    end
  end
  def add_knives(number)
    page.assert_selector('form#1234567898')
    within('#1234567898') do
      fill_in 'quantity', with: number
      click_button 'Add to Cart'
    end
  end
  before :each do
    visit '/'
    add_tables(1)
    click_link 'Continue Shopping'
    add_knives(2)
    click_link 'Proceed to Checkout'
  end

  describe "Item Listing" do
    it "should list items." do
      expect(page).to have_content('Table A')
      expect(page).to have_content('Steak knife')
    end
    it "should provide a subtotal for an item" do
      expect(find(:xpath,"//form[@id='cart_form']").text).to match /Steak knife \$3\.00 2 \$6\.00/
    end

    it "should calculate a subtotal for everything" do
      expect(find(:xpath,"//form[@id='cart_form']").text).to match /Subtotal \$7\.00/
    end
  end

  describe "User Details" do
    it "should have a 'sign in' button" do
      expect(find(:xpath,"//div[@id='user_details']//a[@href='/users/sign_in']").text).to eq 'or Sign In'
    end
  end

  describe "Billing Address" do
    it "should have a select box with state abbreviations" do
      expect(find(:xpath,"//div[@id='billing_address']//select[@id='order_billing_address_attributes_state_id']").text).to eq "AK AL AR AS AZ CA CO CT DC DE FL GA GU HI IA ID IL IN KS KY LA MA MD ME MI MN MO MP MS MT NC ND NE NH NJ NM NV NY OH OK OR PA PR RI SC SD TN TX UM UT VA VI VT WA WI WV WY"
    end
  end
  describe "Shipping Address" do
    it "should have a select box with state abbreviations" do
      expect(find(:xpath,"//div[@id='shipping_address']//select[@id='order_billing_address_attributes_state_id']").text).to eq "AK AL AR AS AZ CA CO CT DC DE FL GA GU HI IA ID IL IN KS KY LA MA MD ME MI MN MO MP MS MT NC ND NE NH NJ NM NV NY OH OK OR PA PR RI SC SD TN TX UM UT VA VI VT WA WI WV WY"
    end
  end

end