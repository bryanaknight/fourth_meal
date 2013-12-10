require 'spec_helper'

describe "the checkout process" do

  it "updates order and directs to confirmation page" do
    add_item_to_order
    click_on 'View Items'
    expect(page).to have_content 'Your Order'
  end

  it "offers guest checkout option if not signed in" do
    new_restaurant = FactoryGirl.create(:restaurant)
    new_item = FactoryGirl.create(:item, restaurant_id: new_restaurant.id)
    visit "/#{new_restaurant.slug}"
    click_on('Add to Cart')
    click_link_or_button('View Items in Cart: 1')
    click_link_or_button('Purchase')
    click_link_or_button('Checkout as Guest')
  end

end

describe "the checkout process for a guest" do

  before do
    new_restaurant = FactoryGirl.create(:restaurant)
    new_item = FactoryGirl.create(:item, restaurant_id: new_restaurant.id)
    visit "/#{new_restaurant.slug}"
    click_on('Add to Cart')
    click_link_or_button('View Items in Cart: 1')
    click_link_or_button('Purchase')
    click_link_or_button('Checkout as Guest')
  end

  describe 'with invalid info' do
    it "redirects back and requires all fields" do
      click_on 'Submit Order'
      page.should have_content 'invalid'
    end
  end

  describe 'with valid info' do
    it 'redirects to confirmation page' do
      fill_in "user_full_name", with: "Test Ing"
      fill_in "user_email", with: "test@example.com"
      fill_in "user_credit_card_number", with: "4242424242424242"
      fill_in "user_billing_street", with: "123 Amber Rd"
      fill_in "user_billing_city", with: "Denver"
      fill_in "user_billing_state", with: "CO"
      fill_in "user_billing_zip_code", with: "80204"
      click_on('Submit Order')
      expect(page).to have_content("Confirmation")
    end
  end

end

describe "the checkout process for a guest which signs in" do

  xit "logging in during checkout redirects back to cart" do
    new_restaurant = FactoryGirl.create(:restaurant)
    new_item = FactoryGirl.create(:item, restaurant_id: new_restaurant.id)
    order = Order.create(restaurant_id: new_restaurant.id,)
    register_user
    click_link_or_button('Log Out')
    visit "/#{new_restaurant.slug}"
    click_on('Add to Cart')
    click_link_or_button('View Items in Cart: 1')
    click_link_or_button('Purchase')
    click_on('Log In')
    fill_in 'Email', :with => "user@example.com"
    fill_in 'Password', :with => "foobarbaz"
    click_button 'Log In'
    page.should have_content "Email"
  end
end





describe "making a new order after purchasing an order" do

  it "should create a new order after purchasing" do
    register_user
    add_item_to_order
    click_on 'View Items'
    click_on 'Purchase'
    visit "/#{@restaurant.slug}"
    click_on('Add to Cart')
    click_on 'View Items'
    expect(page).to have_content('1')
    expect(page).to have_content('unsubmitted')
  end
end

describe "editing quantity in cart" do

  it "should update qty of an item while in the cart" do
    add_item_to_order
    click_on 'View Items in Cart'
    within('.cart_total_price') do
      expect(page).to have_content("$1.09")
    end
    within('.order_item_0') do
      fill_in 'order_item[quantity]', :with => 2
      click_on 'Update'
    end
    within('.order_item_0') do
      expect(page.find_field('order_item[quantity]').value).to eq "2"
    end
    within('.cart_total_price') do
      expect(page).to have_content("$2.18")
    end
  end

end
