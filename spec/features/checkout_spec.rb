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

    it "should have a select box with US and Canada" do
      expect(find(:xpath,"//div[@id='billing_address']//select[@id='order_billing_address_attributes_country_id']").text).to eq "Canada United States"
    end
  end
  describe "Shipping Address" do
    it "should have a select box with state abbreviations" do
      expect(find(:xpath,"//div[@id='shipping_address']//select[@id='order_shipping_address_attributes_state_id']").text).to eq "AK AL AR AS AZ CA CO CT DC DE FL GA GU HI IA ID IL IN KS KY LA MA MD ME MI MN MO MP MS MT NC ND NE NH NJ NM NV NY OH OK OR PA PR RI SC SD TN TX UM UT VA VI VT WA WI WV WY"
    end

    it "should have a select box with US and Canada" do
      expect(find(:xpath,"//div[@id='shipping_address']//select[@id='order_shipping_address_attributes_country_id']").text).to eq "Canada United States"
    end
  end

  describe "Shipping Option" do
    it "should have a shipping option select with two choices" do
      expect(find(:xpath,"//div[@id='shipping']//select[@id='order_line_items_attributes_1_shipment_attributes_shipping_method_id']").text).to eq "Standard Shipping Express Shipping"
    end
  end

  describe "Validations" do
    def fill_form
      fill_in :order_email, with: 'roberto@example.com'
      fill_in :order_phone, with: '1231231234'
      fill_in :order_line_items_attributes_0_payment_attributes_number, with: '4111111111111111'
      fill_in :order_line_items_attributes_0_payment_attributes_verification_value, with: '111'
      select '4', from: 'order_line_items_attributes_0_payment_attributes_month'
      select 2016, from: 'order_line_items_attributes_0_payment_attributes_year'
      fill_in :order_shipping_address_attributes_firstname, with: 'Herman'
      fill_in :order_shipping_address_attributes_lastname, with: 'Munster'
      fill_in :order_shipping_address_attributes_address1, with: '1313 Mocking Bird ln.'
      fill_in :order_shipping_address_attributes_address1, with: 'Suite 13'
      fill_in :order_shipping_address_attributes_city, with: 'Universal Studios'
      select "CA", from: 'order_shipping_address_attributes_state_id'
      select 'United States', from: 'order_shipping_address_attributes_country_id'
      fill_in :order_shipping_address_attributes_zip, with: '91313'
      fill_in :order_billing_address_attributes_firstname, with: 'Herman'
      fill_in :order_billing_address_attributes_lastname, with: 'Munster'
      fill_in :order_billing_address_attributes_address1, with: '1313 Mocking Bird ln.'
      fill_in :order_billing_address_attributes_city, with: 'Universal Studios'
      select "CA", from: 'order_billing_address_attributes_state_id'
      fill_in :order_billing_address_attributes_zip, with: '91313'
      select 'Standard Shipping', from: "order_line_items_attributes_1_shipment_attributes_shipping_method_id"
      select 'United States', from: 'order_billing_address_attributes_country_id'
    end
    before :each do
      fill_form
      page.driver.browser.header('User-Agent', 'capybara_tester')
    end
    it "should fill in the form properly and submit successfully" do
      click_button 'Checkout'
      expect(page).to have_content 'Thanks for your Order'
    end
    describe "User Details" do
      it "should not allow an empty email address" do
        fill_in :order_email, with: ''
        click_button 'Checkout'
        expect(page).to have_content 'Email can\'t be blank'
      end
      it "should not allow an invalid email address" do
        pending "we need to write a validation for this."
        fill_in :order_email, with: 'bogus$bogus.com'
        click_button 'Checkout'
        expect(page).to have_content 'Email invalid'
      end
      it "should not allow an empty phone field" do
        fill_in :order_phone, with: ''
        click_button 'Checkout'
        expect(page).to have_content 'Phone can\'t be blank'
      end

      it "should not allow a bogus phone number" do
        pending "we need to write a validation for this."
        fill_in :order_phone, with: 'this has letters'
        click_button 'Checkout'
        expect(page).to have_content 'Phone can\'t be blank'
      end
    end
    describe "Payment" do
      it "should not allow an empty account field" do
        fill_in :order_line_items_attributes_0_payment_attributes_number, with: ''
        click_button 'Checkout'
        expect(page).to have_content 'Payment number is required'
      end

      it "should not allow an invalid account number account field" do
        fill_in :order_line_items_attributes_0_payment_attributes_number, with: '1234'
        click_button 'Checkout'
        expect(page).to have_content 'Payment number is not a valid credit card number'
      end
      it "should not allow an empty account verification field" do
        fill_in :order_line_items_attributes_0_payment_attributes_verification_value, with: ''
        click_button 'Checkout'
        expect(page).to have_content 'Payment verification value is required'
      end
      it "should not allow an invalid account verification field" do
        fill_in :order_line_items_attributes_0_payment_attributes_verification_value, with: '1111111'
        click_button 'Checkout'
        expect(page).to have_content 'Payment verification value should be 3 digits'
      end
      it "should not allow a four digit verification code for an amex card" do
        pending 'need validation for this amex validations have four digits.'
        fill_in :order_line_items_attributes_0_payment_attributes_verification_value, with: '1111'
        click_button 'Checkout'
        expect(page).to have_content 'Thanks for your Order'
      end
    end
    describe "Billing Address" do

      it "should not allow an empty first name field" do
        fill_in :order_billing_address_attributes_firstname, with: ''
        click_button 'Checkout'
        expect(page).to have_content 'Billing address firstname can\'t be blank'
      end

      it "should not allow an empty last name field" do
        fill_in :order_billing_address_attributes_lastname, with: ''
        click_button 'Checkout'
        expect(page).to have_content 'Billing address lastname can\'t be blank'
      end

      it "should not allow an empty address1 field" do
        fill_in :order_billing_address_attributes_address1, with: ''
        click_button 'Checkout'
        expect(page).to have_content 'Billing address address1 can\'t be blank'
      end
      it "should allow an empty address2 field" do
        fill_in :order_billing_address_attributes_address2, with: ''
        click_button 'Checkout'
        expect(page).to have_content 'Thanks for your Order'
      end
      it "should not allow an empty city field" do
        fill_in :order_billing_address_attributes_city, with: ''
        click_button 'Checkout'
        expect(page).to have_content 'Billing address city can\'t be blank'
      end

      it "should not allow an empty zip field" do
        fill_in :order_billing_address_attributes_zip, with: ''
        click_button 'Checkout'
        expect(page).to have_content 'Billing address zip can\'t be blank'
      end
    end
    
    describe "Shipping address" do
      it "should not allow an empty shipping first name field" do
        fill_in :order_shipping_address_attributes_firstname, with: ''
        click_button 'Checkout'
        expect(page).to have_content 'Shipping address firstname can\'t be blank'
      end

      it "should not allow an empty last name field" do
        fill_in :order_shipping_address_attributes_lastname, with: ''
        click_button 'Checkout'
        expect(page).to have_content 'Shipping address lastname can\'t be blank'
      end

      it "should not allow an empty address1 field" do
        fill_in :order_shipping_address_attributes_address1, with: ''
        click_button 'Checkout'
        expect(page).to have_content 'Shipping address address1 can\'t be blank'
      end
      it "should allow an empty address2 field" do
        fill_in :order_shipping_address_attributes_address2, with: ''
        click_button 'Checkout'
        expect(page).to have_content 'Thanks for your Order'
      end
      it "should not allow an empty city field" do
        fill_in :order_shipping_address_attributes_city, with: ''
        click_button 'Checkout'
        expect(page).to have_content 'Shipping address city can\'t be blank'
      end

      it "should not allow an empty zip field" do
        fill_in :order_shipping_address_attributes_zip, with: ''
        click_button 'Checkout'
        expect(page).to have_content 'Shipping address zip can\'t be blank'
      end
    end

  end

end